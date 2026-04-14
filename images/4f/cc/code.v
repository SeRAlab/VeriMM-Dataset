module top_module(
  input [n-1:0] addr,
  input [m-1:0] ctrl,
  output reg en // Change output to reg type
);parameter n = 8; // number of memory address signals
parameter m = 4; // number of control signals
parameter p = 2; // number of memory protection blocks

reg [n-1:0] start_addr [0:p-1];
reg [n-1:0] end_addr [0:p-1];
reg [p-1:0] allow_access;

integer i;

// Initialize memory protection block parameters
initial begin
  start_addr[0] = 8'h00; // Start address for block 0
  end_addr[0] = 8'h3F;   // End address for block 0
  start_addr[1] = 8'h80; // Start address for block 1
  end_addr[1] = 8'hBF;   // End address for block 1
end

// Configure memory protection blocks based on control signals
always @(*) begin
  allow_access = 0;
  for (i = 0; i < p; i = i + 1) begin
    if ((ctrl[i] == 1) && (ctrl[i+p] == 0)) begin
      allow_access[i] = 1;
    end
  end
end

// Check memory address against memory protection blocks
always @(*) begin
  en = 1;
  for (i = 0; i < p; i = i + 1) begin
    if ((addr >= start_addr[i]) && (addr <= end_addr[i])) begin
      if (allow_access[i] == 0) begin
        en = 0;
      end
    end
  end
end

endmodule