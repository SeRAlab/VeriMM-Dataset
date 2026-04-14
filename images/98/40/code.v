module shift_register(
    input clk,
    input reset,
    input [10:0] data_in,
    output reg [10:0] data_out
    );
    
    always @(posedge clk or posedge reset) begin
        if (reset)
            data_out <= 11'b11111111111;
        else
            data_out <= {data_in[0], data_out[10:1]};
    end
endmodule