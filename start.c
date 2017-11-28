extern unsigned int __etext, __data_start__, __data_end__, __bss_start__, __bss_end__, __stack;

extern int main();

void Default_Reset_Handler(void);
void Default_Handler(void);

_Noreturn void Default_Reset_Handler(void) {
  unsigned int *src = &__etext;
  unsigned int *dst = &__data_start__;

  /* ROM has data at end of text; copy it.  */
  while (dst < &__data_end__)
    *dst++ = *src++;

  /* Zero bss.  */
  for (dst = &__bss_start__; dst < &__bss_end__; dst++)
    *dst = 0;

  main();

  while (1)
    ;
}

_Noreturn void Default_Handler(void) {
  while (1)
    ;
}

void Reset_Handler(void) __attribute((weak, alias("Default_Reset_Handler")));
void NMI_Handler(void) __attribute((weak, alias("Default_Handler")));
void HardFault_Handler(void) __attribute((weak, alias("Default_Handler")));
void MemManage_Handler(void) __attribute((weak, alias("Default_Handler")));
void BusFault_Handler(void) __attribute((weak, alias("Default_Handler")));
void UsageFault_Handler(void) __attribute((weak, alias("Default_Handler")));
void SVCall_Handler(void) __attribute((weak, alias("Default_Handler")));
void DebugMon_Handler(void) __attribute((weak, alias("Default_Handler")));
void PendSV_Handler(void) __attribute((weak, alias("Default_Handler")));
void SysTick_Handler(void) __attribute((weak, alias("Default_Handler")));

__attribute__((section(".isr_vector"),used)) static void *vectors[] = {
    (void *)&__stack,
    (void *)&Reset_Handler,      /* Reset Handler */
    (void *)&NMI_Handler,        /* NMI Handler */
    (void *)&HardFault_Handler,  /* Hard Fault Handler */
    (void *)&MemManage_Handler,  /* MPU Fault Handler */
    (void *)&BusFault_Handler,   /* Bus Fault Handler */
    (void *)&UsageFault_Handler, /* Usage Fault Handler */
    0,                           /* Reserved */
    0,                           /* Reserved */
    0,                           /* Reserved */
    0,                           /* Reserved */
    (void *)&SVCall_Handler,     /* SVCall Handler */
    (void *)&DebugMon_Handler,   /* Debug Monitor Handler */
    0,                           /* Reserved */
    (void *)&PendSV_Handler,     /* PendSV Handler */
    (void *)&SysTick_Handler,    /* SysTick Handler */
};
