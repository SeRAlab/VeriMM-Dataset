module ShiftRegister (
    input clk,
    input reset,
    input load,
    input shift,
    input [7:0] data_in,
    output reg [7:0] data_out
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            data_out <= 8'b0;
        end else if (load) begin
            data_out <= data_in;
        end else if (shift) begin
            data_out <= {data_out[6:0], 1'b0}; // Shift left
        end else begin
            data_out <= {1'b0, data_out[7:1]}; // Shift right
        end
    end
endmodule