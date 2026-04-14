module top_module(
    input [31:0] data_in,
    output reg[31:0] data_out
);always @(*)
    begin
        if(data_in[31])                 
            data_out <= 32'd0;
        else
            data_out <= data_in;     
    end
endmodule