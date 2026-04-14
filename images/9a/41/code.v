module shift_register(
    input clk,
    input reset,
    input [15:0] data_in,
    output reg [15:0] data_out
    );
    
    always @(posedge clk) begin
        if (reset)
            data_out <= 16'b0000000000000000;
        else
            data_out <= {data_out[14:0], data_in[15]};
    end
endmodule