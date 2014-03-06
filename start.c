extern unsigned int _etext, _data, _edata, _bstart, _bend, _estack;

extern int main(void);

void DefaultReset_Handler(void) {
  unsigned int *src = &_etext;
  unsigned int *dst = &_data;
  /* ROM has data at end of text; copy it.  */
  while (dst < &_edata)
    *dst++ = *src++;
  /* Zero bss.  */
  for (dst = &_bstart; dst< &_bend; dst++)
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

__attribute__((section(".vectors"))) void *vectors[] = {
  (void*) &_estack,
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
