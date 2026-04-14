module top_module(a_in , c_out);input [31:0] a_in;
  output [31:0] c_out; 

  reg [31:0] decnum;

  reg [31:0] result;
  reg [7:0] temp;
  assign c_out = result;

  always@(a_in) begin
    result = 32'b0;
    decnum = a_in;

    temp = decnum / 360000; decnum = decnum % 360000;
    result[31:28] = temp / 10; result[27:24] = temp % 10;

    temp = decnum / 6000; decnum = decnum % 6000;
    result[23:20] = temp / 10; result[19:16] = temp % 10;

    temp = decnum / 100; decnum = decnum % 100;
    result[15:12] = temp / 10; result[11:8] = temp % 10;

    result[7:4] = decnum / 10; result[3:0] = decnum % 10;
  end
 endmodule