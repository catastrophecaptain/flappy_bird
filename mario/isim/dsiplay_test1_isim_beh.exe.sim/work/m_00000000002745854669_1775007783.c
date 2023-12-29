/**********************************************************************/
/*   ____  ____                                                       */
/*  /   /\/   /                                                       */
/* /___/  \  /                                                        */
/* \   \   \/                                                       */
/*  \   \        Copyright (c) 2003-2009 Xilinx, Inc.                */
/*  /   /          All Right Reserved.                                 */
/* /---/   /\                                                         */
/* \   \  /  \                                                      */
/*  \___\/\___\                                                    */
/***********************************************************************/

/* This file is designed for use with ISim build 0x7708f090 */

#define XSI_HIDE_SYMBOL_SPEC true
#include "xsi.h"
#include <memory.h>
#ifdef __GNUC__
#include <stdlib.h>
#else
#include <malloc.h>
#define alloca _alloca
#endif
static const char *ng0 = "D:/mario/dsiplay_test1.v";
static unsigned int ng1[] = {1U, 0U};
static unsigned int ng2[] = {0U, 0U};
static unsigned int ng3[] = {10U, 0U};
static unsigned int ng4[] = {51258U, 0U};
static unsigned int ng5[] = {204880U, 0U};
static unsigned int ng6[] = {409700U, 0U};



static void Always_37_0(char *t0)
{
    char *t1;
    char *t2;
    char *t3;
    char *t4;

LAB0:    t1 = (t0 + 4928U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(37, ng0);

LAB4:    xsi_set_current_line(38, ng0);
    t2 = (t0 + 4736);
    xsi_process_wait(t2, 1LL);
    *((char **)t1) = &&LAB5;

LAB1:    return;
LAB5:    xsi_set_current_line(38, ng0);
    t3 = ((char*)((ng1)));
    t4 = (t0 + 3048);
    xsi_vlogvar_assign_value(t4, t3, 0, 0, 1);
    xsi_set_current_line(39, ng0);
    t2 = (t0 + 4736);
    xsi_process_wait(t2, 1LL);
    *((char **)t1) = &&LAB6;
    goto LAB1;

LAB6:    xsi_set_current_line(39, ng0);
    t3 = ((char*)((ng2)));
    t4 = (t0 + 3048);
    xsi_vlogvar_assign_value(t4, t3, 0, 0, 1);
    goto LAB2;

}

static void Initial_41_1(char *t0)
{
    char *t1;
    char *t2;

LAB0:    xsi_set_current_line(41, ng0);

LAB2:    xsi_set_current_line(42, ng0);
    t1 = ((char*)((ng2)));
    t2 = (t0 + 3208);
    xsi_vlogvar_assign_value(t2, t1, 0, 0, 1);
    xsi_set_current_line(43, ng0);
    t1 = ((char*)((ng2)));
    t2 = (t0 + 3368);
    xsi_vlogvar_assign_value(t2, t1, 0, 0, 16);
    xsi_set_current_line(44, ng0);
    t1 = ((char*)((ng3)));
    t2 = (t0 + 3528);
    xsi_vlogvar_assign_value(t2, t1, 0, 0, 16);
    xsi_set_current_line(45, ng0);
    t1 = ((char*)((ng4)));
    t2 = (t0 + 3688);
    xsi_vlogvar_assign_value(t2, t1, 0, 0, 32);
    xsi_set_current_line(46, ng0);
    t1 = ((char*)((ng5)));
    t2 = (t0 + 3848);
    xsi_vlogvar_assign_value(t2, t1, 0, 0, 32);
    xsi_set_current_line(47, ng0);
    t1 = ((char*)((ng6)));
    t2 = (t0 + 4008);
    xsi_vlogvar_assign_value(t2, t1, 0, 0, 32);

LAB1:    return;
}


extern void work_m_00000000002745854669_1775007783_init()
{
	static char *pe[] = {(void *)Always_37_0,(void *)Initial_41_1};
	xsi_register_didat("work_m_00000000002745854669_1775007783", "isim/dsiplay_test1_isim_beh.exe.sim/work/m_00000000002745854669_1775007783.didat");
	xsi_register_executes(pe);
}
