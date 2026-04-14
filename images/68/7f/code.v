module top_module(
  input [2:0] address, 
  input writeEn, 
  input strobe_i,
  input busClk, 
  input usbClk, 
  input rstSyncToBusClk, 
  input fifoSelect,
  input [7:0] fifoDataIn,
  input [7:0] busDataIn, 
  output reg [7:0] busDataOut,
  output reg fifoREn,
  output reg forceEmptySyncToUsbClk,
  output reg forceEmptySyncToBusClk,
  input [15:0] numElementsInFifo
  );reg forceEmptyReg;
reg forceEmpty;
reg forceEmptyToggle;
reg [2:0] forceEmptyToggleSyncToUsbClk;

//sync write
always @(posedge busClk)
begin
  if (writeEn == 1'b1 && fifoSelect == 1'b1 && 
    address == 3'b100 && strobe_i == 1'b1 && busDataIn[0] == 1'b1)
    forceEmpty <= 1'b1;
  else
    forceEmpty <= 1'b0;
end

//detect rising edge of 'forceEmpty', and generate toggle signal
always @(posedge busClk) begin
  if (rstSyncToBusClk == 1'b1) begin
    forceEmptyReg <= 1'b0;
    forceEmptyToggle <= 1'b0;
  end
  else begin
    if (forceEmpty == 1'b1)
      forceEmptyReg <= 1'b1;
    else
      forceEmptyReg <= 1'b0;
    if (forceEmpty == 1'b1 && forceEmptyReg == 1'b0)
      forceEmptyToggle <= ~forceEmptyToggle;
  end
end
assign forceEmptySyncToBusClk = (forceEmpty == 1'b1 && forceEmptyReg == 1'b0) ? 1'b1 : 1'b0;


// double sync across clock domains to generate 'forceEmptySyncToUsbClk'
always @(posedge usbClk) begin
    forceEmptyToggleSyncToUsbClk <= {forceEmptyToggleSyncToUsbClk[1:0], forceEmptyToggle};
end
assign forceEmptySyncToUsbClk = forceEmptyToggleSyncToUsbClk[2] ^ forceEmptyToggleSyncToUsbClk[1];

// async read mux
always @(address or fifoDataIn or numElementsInFifo)
begin
  case (address)
      3'b000 : busDataOut <= fifoDataIn;
      3'b001 : busDataOut <= numElementsInFifo[15:8];
      3'b010 : busDataOut <= numElementsInFifo[7:0];
      default: busDataOut <= 8'h00; 
  endcase
end

//generate fifo read strobe
always @(address or writeEn or strobe_i or fifoSelect) begin
  if (address == 3'b000 && writeEn == 1'b0 && 
  strobe_i == 1'b1 && fifoSelect == 1'b1)
    fifoREn <= 1'b1;
  else
    fifoREn <= 1'b0;
end


endmodule