module top_module(
  // Outputs
  output [31:0] rd0_data, rd1_data, rd2_data,
  // Inputs
  input [9:0] rd0_addr, rd1_addr, rd2_addr, 
  input [9:0] wr0_addr, 
  input [3:0] wr0_en, 
  input [31:0] wr0_data, 
  input clk
);// Define the register file
  reg [31:0] reg_file [0:1023];

  // Define the read port logic
  assign rd0_data = reg_file[rd0_addr];
  assign rd1_data = reg_file[rd1_addr];
  assign rd2_data = reg_file[rd2_addr];

  // Define the write port logic
  always @(posedge clk) begin
    if (wr0_en[0]) reg_file[wr0_addr] <= wr0_data; // Assuming single word writes
  end

endmodule