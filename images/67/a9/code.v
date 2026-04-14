module top_module(
    input   wire   [31:0]   Memory_data, 
    output  wire   [31:0]   Sign_out_32 
);assign Sign_out_32 = {{24{1'b0}}, Memory_data[7:0]}; 

endmodule