/*
 * This file contains device specific hooks.
 * Always enclose hooks to #if MR_DEVICE_HOOKS >= ver
 * with corresponding hook version!
 */

#include <stdio.h>
#include <unistd.h>
#include <sys/stat.h>
#include <stdint.h>
#include <time.h>
#include <string.h>

#include <log.h>

#if MR_DEVICE_HOOKS >= 1
int mrom_hook_after_android_mounts(const char *busybox_path, const char *base_path, int type)
{
    return 0;
}
#endif /* MR_DEVICE_HOOKS >= 1 */


#if MR_DEVICE_HOOKS >= 2
// Screen gets cleared immediatelly after closing the framebuffer on this device,
// give user a while to read the message box until it dissapears.
void mrom_hook_before_fb_close(void)
{
    usleep(800000);
}
#endif /* MR_DEVICE_HOOKS >= 2 */


#if MR_DEVICE_HOOKS >= 3
static int read_file(const char *path, char *dest, int dest_size)
{
    int res = 0;
    FILE *f = fopen(path, "r");
    if(!f)
        return res;

    res = fgets(dest, dest_size, f) != NULL;
    fclose(f);
    return res;
}

static int write_file(const char *path, const char *what)
{
    int res = 0;
    FILE *f = fopen(path, "w");
    if(!f)
        return res;

    res = fputs(what, f) >= 0;
    fclose(f);
    return res;
}

static void set_cpu_governor(void)
{
    size_t i;
    char buff[256];
    static const char *governors[] = { "interactive", "ondemand" };

    if(!read_file("/sys/devices/system/cpu/cpu0/cpufreq/scaling_governor", buff, sizeof(buff)))
        return;

    if(strncmp(buff, "performance", 11) != 0)
        return;

    if(!read_file("/sys/devices/system/cpu/cpu0/cpufreq/scaling_available_governors", buff, sizeof(buff)))
        return;

    write_file("/sys/module/msm_thermal/core_control/enabled", "0");
    write_file("/sys/devices/system/cpu/cpu1/online", "1");
    write_file("/sys/devices/system/cpu/cpu2/online", "1");
    write_file("/sys/devices/system/cpu/cpu3/online", "1");

    for(i = 0; i < sizeof(governors)/sizeof(governors[0]); ++i)
    {
        if(strstr(buff, governors[i]))
        {
            write_file("/sys/devices/system/cpu/cpu0/cpufreq/scaling_governor", governors[i]);
            write_file("/sys/devices/system/cpu/cpu1/cpufreq/scaling_governor", governors[i]);
            write_file("/sys/devices/system/cpu/cpu2/cpufreq/scaling_governor", governors[i]);
            write_file("/sys/devices/system/cpu/cpu3/cpufreq/scaling_governor", governors[i]);
            break;
        }
    }

    write_file("/sys/devices/system/cpu/cpufreq/ondemand/up_threshold","90");
    write_file("/sys/devices/system/cpu/cpufreq/ondemand/sampling_rate","50000");
    write_file("/sys/devices/system/cpu/cpufreq/ondemand/io_is_busy","1");
    write_file("/sys/devices/system/cpu/cpufreq/ondemand/sampling_down_factor","4");
    write_file("/sys/devices/system/cpu/cpufreq/ondemand/down_differential","10");
    write_file("/sys/devices/system/cpu/cpufreq/ondemand/up_threshold_multi_core","70");
    write_file("/sys/devices/system/cpu/cpufreq/ondemand/down_differential_multi_core","3");
    write_file("/sys/devices/system/cpu/cpufreq/ondemand/optimal_freq","960000");
    write_file("/sys/devices/system/cpu/cpufreq/ondemand/sync_freq","960000");
    write_file("/sys/devices/system/cpu/cpufreq/ondemand/up_threshold_any_cpu_load","80");
    write_file("/sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq","300000");
    write_file("/sys/devices/system/cpu/cpu1/cpufreq/scaling_min_freq","300000");
    write_file("/sys/devices/system/cpu/cpu2/cpufreq/scaling_min_freq","300000");
    write_file("/sys/devices/system/cpu/cpu3/cpufreq/scaling_min_freq","300000");

    write_file("/sys/module/msm_thermal/core_control/enabled", "1");
}

void tramp_hook_before_device_init(void)
{
    // shamu's kernel has "performance" as default
    set_cpu_governor();
}
#endif /* MR_DEVICE_HOOKS >= 3 */

#if MR_DEVICE_HOOKS >= 4
int mrom_hook_allow_incomplete_fstab(void)
{
    return 0;
}
#endif

#if MR_DEVICE_HOOKS >= 5

static void replace_tag(char *cmdline, size_t cap, const char *tag, const char *what)
{
    char *start, *end;
    char *str = cmdline;
    char *str_end = str + strlen(str);
    size_t replace_len = strlen(what);

    while((start = strstr(str, tag)))
    {
        end = strstr(start, " ");
        if(!end)
            end = str_end;
        else if(replace_len == 0)
            ++end;

        if(end != start)
        {

            size_t len = str_end - end;
            if((start - cmdline)+replace_len+len > cap)
                len = cap - replace_len - (start - cmdline);
            memmove(start+replace_len, end, len+1); // with \0
            memcpy(start, what, replace_len);
        }

        str = start+replace_len;
    }
}

int mrom_hook_cmdline_remove_bootimg_part(char *bootimg_cmdline, size_t bootimg_cmdline_cap, char *complete_cmdline, size_t complete_cmdline_cap)
{
    // Shamu's bootloader replaces all occurences of console=... with console=null, because fuck you.
    replace_tag(bootimg_cmdline, bootimg_cmdline_cap, "androidboot.console=", "");
    replace_tag(bootimg_cmdline, bootimg_cmdline_cap, "console=", "console=null");
    return 0;
}
#endif
