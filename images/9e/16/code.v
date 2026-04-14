module shift_right (
    input clk,
    input reset,
    input [7:0] data_in,
    output reg [7:0] data_out
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            data_out <= 8'b00000000;
        end else begin
            data_out <= {1'b0, data_in[7:1]};
        end
    end
endmodule