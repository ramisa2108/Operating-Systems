# xv6 Memory Management

An important feature lacking in xv6 is the ability to swap out pages to a backing store. That is,at each moment in time all processes are held within the physical memory. Here a paging framework is implemented for xv6 which can take out pages and store them to disk. Also, the framework retrieves pages back to the memory on demand. In the framework, each process is responsible for paging in and out its own pages.

2 page replacement algorithms are implemented:
1. FIFO
2. Aging (LRU)


Changes made in xv6:

- `Makefile`  
	CPUS set to 1

- `defs.h`  
	New function and struct declarations

- `mmu.h`  
    New constant declarations

- `proc.h`  
    - `struct pagemeta` for holding physical and swapped pages' metadata  
    - `struct proc` : new fields for swapping added  
  
- `proc.c`  
    - `allocproc` : creating swap file, initializing process page meta
    - `fork` : copying swap file and page meta
    - `exit` : removing swap file, clearing page meta
    - `procdump` : updating process details viewer
    - Utility functions for supporting paging framework:
      - `clearPages`
      - `printPages`
      - `getNextPhysicalPage`
      - `addPhysicalPage`
      - `removePhysicalPage`
      - `getPhysicalPage`
      - `getSwapPage`
      - `removeSwapPage`
      - `addSwapPage`
      - `getEmptySwapPosition`
      - `updateAllProcessPTE` (used only for aging)

- `fs.c`
  - `craeteSwapFile`
  - `removeSwapFile`
  - `readFromSwapFile`
  - `writeToSwapFile`
  - `copySwapFile`

- `vm.c`
  - `allocuvm` : adding physical pages, swapping out some pages if needed
  - `deallocuvm` : removing physical or swapped pages from process
  - `copyuvm` : copying physical and swapped pages from parent 
  - Functions for supporting paging framework:  
    - `copyPagesFromParent` : copying page metadata from parent to child
    - `swapout` : swapping out a physical page to swap file
    - `swapin` : swapping in a page from swap file to physical memory
    - `checkPageOut` : checking for a page in swap file
    - `clearPTE_A` : clearing PTE_A flag and calculating age of pages (used only for aging)

- `trap.c`
  - `case T_IRQ0 + IRQ_TIMER` : calling `clearPTE_A` function in `vm.c`
  - `case T_PGFLT` : calling `checkPageOut` and `swapin`  functions in `vm.c` in case of pagefaults  

- Check `swapping.patch` for details of the changes