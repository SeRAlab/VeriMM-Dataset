module register_8bit (
    input [7:0] data_in,
    input clk,
    input reset,
    output reg [7:0] data_out
);

    always @(posedge clk or posedge reset) begin
        if (reset)
            data_out <= 8'b00000000;
        else
            data_out <= data_in;
    end

endmodule