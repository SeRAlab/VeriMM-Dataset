module top_module(
    
    data_in, io, 

    
    data_out);input  [31:0]  data_in;
    input          io;

    output [31:0]  data_out;
    
    wire    [31:0]  result = 32'b0;
    wire    [31:0]  value;
    wire    [15:0]  val16;
    wire    [7:0]   val8;
    wire    [3:0]   val4;
    assign  value = io ? ~data_in : data_in;
    assign  result[4] = (value[31:16] == 16'b0);
    assign  val16     = result[4] ? value[15:0] : value[31:16];
    assign  result[3] = (val16[15:8] == 8'b0);
    assign  val8      = result[3] ? val16[7:0] : val16[15:8];
    assign  result[2] = (val8[7:4] == 4'b0);
    assign  val4      = result[2] ? val8[3:0] : val8[7:4];
    assign  result[1] = (val4[3:2] == 2'b0);
    assign  result[0] = result[1] ? ~val4[1] : ~val4[3];
    
    assign  data_out = result;
endmodule