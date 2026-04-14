module register(
    input clk,
    input reset,
    input [15:0] data_in,
    output reg [15:0] data_out
    );
    
    always @(posedge clk) begin
        if (reset)
            data_out <= 16'd0;
        else
            data_out <= data_in;
    end
endmodule