module top_module(output wire oLDST_REQ,input wire iLDST_BUSY,output wire [1:0] oLDST_ORDER,output wire [3:0] oLDST_MASK,output wire oLDST_RW,output wire [13:0] oLDST_TID,output wire [1:0] oLDST_MMUMOD,output wire [31:0] oLDST_PDT,output wire [31:0] oLDST_ADDR,output wire [31:0] oLDST_DATA,input wire iLDST_VALID,input wire iLDST_PAGEFAULT,input wire [13:0] iLDST_MMU_FLAGS,input wire [31:0] iLDST_DATA,input wire iUSE_SEL,input wire iEXE_REQ,output wire oEXE_BUSY,input wire [1:0] iEXE_ORDER,input wire [3:0] iEXE_MASK,input wire iEXE_RW,input wire [13:0] iEXE_TID,input wire [1:0] iEXE_MMUMOD,input wire [31:0] iEXE_PDT,input wire [31:0] iEXE_ADDR,input wire [31:0] iEXE_DATA,output wire oEXE_REQ,output wire oEXE_PAGEFAULT,output wire [13:0] oEXE_MMU_FLAGS,output wire [31:0] oEXE_DATA,input wire iEXCEPT_REQ,output wire oEXCEPT_BUSY,input wire [1:0] iEXCEPT_ORDER,input wire iEXCEPT_RW,input wire [13:0] iEXCEPT_TID,input wire [1:0] iEXCEPT_MMUMOD,input wire [31:0] iEXCEPT_PDT,input wire [31:0] iEXCEPT_ADDR,input wire [31:0] iEXCEPT_DATA,output wire oEXCEPT_REQ,output wire [31:0] oEXCEPT_DATA);assign oLDST_REQ = (iUSE_SEL)? iEXCEPT_REQ : iEXE_REQ; 
  assign oLDST_ORDER = (iUSE_SEL)? iEXCEPT_ORDER : iEXE_ORDER; 
  assign oLDST_MASK = (iUSE_SEL)? 4'hf : iEXE_MASK; 
  assign oLDST_RW = (iUSE_SEL)? iEXCEPT_RW : iEXE_RW; 
  assign oLDST_TID = (iUSE_SEL)? iEXCEPT_TID : iEXE_TID; 
  assign oLDST_MMUMOD = (iUSE_SEL)? iEXCEPT_MMUMOD : iEXE_MMUMOD; 
  assign oLDST_PDT = (iUSE_SEL)? iEXCEPT_PDT : iEXE_PDT; 
  assign oLDST_ADDR = (iUSE_SEL)? iEXCEPT_ADDR : iEXE_ADDR; 
  assign oLDST_DATA = (iUSE_SEL)? iEXCEPT_DATA : iEXE_DATA; 
  assign oEXCEPT_BUSY = (iUSE_SEL)? iLDST_BUSY : 1'b1; 
  assign oEXCEPT_REQ = (iUSE_SEL)? iLDST_VALID : 1'b0; 
  assign oEXCEPT_DATA = iLDST_DATA; 
  assign oEXE_BUSY = (iUSE_SEL)? 1'b1 : iLDST_BUSY; 
  assign oEXE_REQ = (iUSE_SEL)? 1'b0 : iLDST_VALID; 
  assign oEXE_PAGEFAULT = iLDST_PAGEFAULT; 
  assign oEXE_MMU_FLAGS = iLDST_MMU_FLAGS; 
  assign oEXE_DATA = iLDST_DATA; 
 endmodule