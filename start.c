extern unsigned int __etext, __data_start__, __data_end__, __bss_start__, __bss_end__, __stack;

extern int main(void);

void DefaultReset_Handler(void) {
  unsigned int *src = &__etext;
  unsigned int *dst = &__data_start__;
  /* ROM has data at end of text; copy it.  */
  while (dst < &__data_end__)
    *dst++ = *src++;
  /* Zero bss.  */
  for (dst = &__bss_start__; dst< &__bss_end__; dst++)
    *dst = 0;
  main();
  while(1)
    ;
}

void Default_Handler(void) {
  while(1)
    ;
}

void Reset_Handler(void) __attribute ((weak, alias ("DefaultReset_Handler")));
void NMI_Handler(void) __attribute ((weak, alias ("Default_Handler")));
void HardFault_Handler(void) __attribute ((weak, alias ("Default_Handler")));
void MemManage_Handler(void) __attribute ((weak, alias ("Default_Handler")));
void BusFault_Handler(void) __attribute ((weak, alias ("Default_Handler")));
void UsageFault_Handler(void) __attribute ((weak, alias ("Default_Handler")));
void SVCall_Handler(void) __attribute ((weak, alias ("Default_Handler")));
void DebugMon_Handler(void) __attribute ((weak, alias ("Default_Handler")));
void PendSV_Handler(void) __attribute ((weak, alias ("Default_Handler")));
void SysTick_Handler(void) __attribute ((weak, alias ("Default_Handler")));

__attribute__((section(".isr_vector"))) void *vectors[] = {
  (void*) &__stack,
  Reset_Handler,             /* Reset Handler */
  NMI_Handler,               /* NMI Handler */
  HardFault_Handler,         /* Hard Fault Handler */
  MemManage_Handler,         /* MPU Fault Handler */
  BusFault_Handler,          /* Bus Fault Handler */
  UsageFault_Handler,        /* Usage Fault Handler */
  0,                         /* Reserved */
  0,                         /* Reserved */
  0,                         /* Reserved */
  0,                         /* Reserved */
  SVCall_Handler,            /* SVCall Handler */
  DebugMon_Handler,          /* Debug Monitor Handler */
  0,                         /* Reserved */
  PendSV_Handler,            /* PendSV Handler */
  SysTick_Handler,           /* SysTick Handler */
};
