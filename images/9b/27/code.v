module top_module(
    input [3:0] data_in,
    input enable,
    output reg [1:0] data_out
);always @ (data_in, enable) begin
        if (enable) begin
            data_out = data_in[1:0];
        end else begin
            data_out = 2'b0;
        end
    end
    
endmodule