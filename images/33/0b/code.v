module shift_register (
    input wire clk,
    input wire reset,
    input wire [3:0] data_in,
    output reg [3:0] data_out
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            data_out <= 4'b0000;
        end else begin
            data_out <= {data_out[2:0], 1'b0}; // Shift left and fill with 0
        end
    end
endmodule