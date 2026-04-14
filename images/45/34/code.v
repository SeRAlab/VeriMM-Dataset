module top_module(
  input [0:0] data_in,
  input crc_en,
  output [15:0] crc_out,
  input rst,
  input clk);reg [15:0] lfsr_q,lfsr_c;

  assign crc_out = lfsr_q;

  always @(*) begin
    lfsr_c[0] = lfsr_q[15] ^ data_in[0];
    lfsr_c[1] = lfsr_q[0];
    lfsr_c[2] = lfsr_q[1] ^ lfsr_q[15] ^ data_in[0];
    lfsr_c[3] = lfsr_q[2];
    lfsr_c[4] = lfsr_q[3];
    lfsr_c[5] = lfsr_q[4];
    lfsr_c[6] = lfsr_q[5];
    lfsr_c[7] = lfsr_q[6];
    lfsr_c[8] = lfsr_q[7];
    lfsr_c[9] = lfsr_q[8];
    lfsr_c[10] = lfsr_q[9];
    lfsr_c[11] = lfsr_q[10];
    lfsr_c[12] = lfsr_q[11];
    lfsr_c[13] = lfsr_q[12];
    lfsr_c[14] = lfsr_q[13];
    lfsr_c[15] = lfsr_q[14] ^ lfsr_q[15] ^ data_in[0];

  end 

  always @(posedge clk, posedge rst) begin
    if(rst) begin
      lfsr_q <= {16{1'b0}};
    end
    else begin
      lfsr_q <= crc_en ? lfsr_c : lfsr_q;
    end
  end 
endmodule