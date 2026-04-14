module shift_register (
    input wire [15:0] data_in,
    input wire direction, // 0 for left, 1 for right
    input wire clk,
    output reg [15:0] data_out
);
    always @(posedge clk) begin
        if (direction == 0) begin
            data_out <= {data_out[14:0], 1'b0}; // Shift left
        end else begin
            data_out <= {1'b0, data_out[15:1]}; // Shift right
        end
    end
endmodule