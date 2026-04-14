module top_module(
  input [7:0] d,
  input dv,
  output [15:0] crc,
  input rst,
  input c);reg [15:0] crc_q, crc_d;

  
  wire [7:0] df = { d[0], d[1], d[2], d[3], d[4], d[5], d[6], d[7] };
  assign crc = { ~crc_q[ 0], ~crc_q[ 1], ~crc_q[ 2], ~crc_q[ 3],
                 ~crc_q[ 4], ~crc_q[ 5], ~crc_q[ 6], ~crc_q[ 7],
                 ~crc_q[ 8], ~crc_q[ 9], ~crc_q[10], ~crc_q[11],
                 ~crc_q[12], ~crc_q[13], ~crc_q[14], ~crc_q[15]  };

  always @(*) begin
    crc_d[0] = crc_q[8] ^ crc_q[9] ^ crc_q[10] ^ crc_q[11] ^ crc_q[12] ^ crc_q[13] ^ crc_q[14] ^ crc_q[15] ^ df[0] ^ df[1] ^ df[2] ^ df[3] ^ df[4] ^ df[5] ^ df[6] ^ df[7];
    crc_d[1] = crc_q[9] ^ crc_q[10] ^ crc_q[11] ^ crc_q[12] ^ crc_q[13] ^ crc_q[14] ^ crc_q[15] ^ df[1] ^ df[2] ^ df[3] ^ df[4] ^ df[5] ^ df[6] ^ df[7];
    crc_d[2] = crc_q[8] ^ crc_q[9] ^ df[0] ^ df[1];
    crc_d[3] = crc_q[9] ^ crc_q[10] ^ df[1] ^ df[2];
    crc_d[4] = crc_q[10] ^ crc_q[11] ^ df[2] ^ df[3];
    crc_d[5] = crc_q[11] ^ crc_q[12] ^ df[3] ^ df[4];
    crc_d[6] = crc_q[12] ^ crc_q[13] ^ df[4] ^ df[5];
    crc_d[7] = crc_q[13] ^ crc_q[14] ^ df[5] ^ df[6];
    crc_d[8] = crc_q[0] ^ crc_q[14] ^ crc_q[15] ^ df[6] ^ df[7];
    crc_d[9] = crc_q[1] ^ crc_q[15] ^ df[7];
    crc_d[10] = crc_q[2];
    crc_d[11] = crc_q[3];
    crc_d[12] = crc_q[4];
    crc_d[13] = crc_q[5];
    crc_d[14] = crc_q[6];
    crc_d[15] = crc_q[7] ^ crc_q[8] ^ crc_q[9] ^ crc_q[10] ^ crc_q[11] ^ crc_q[12] ^ crc_q[13] ^ crc_q[14] ^ crc_q[15] ^ df[0] ^ df[1] ^ df[2] ^ df[3] ^ df[4] ^ df[5] ^ df[6] ^ df[7];

  end 

  always @(posedge c) begin
    if(rst)
      crc_q <= {16{1'b1}};
    else 
      crc_q <= dv ? crc_d : crc_q;
  end 
endmodule