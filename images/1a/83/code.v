module shift_register (
    input clk,
    input load,
    input shift_direction, // 0 for left, 1 for right
    input [3:0] data_in,
    output reg [3:0] data_out
);
    always @(posedge clk) begin
        if (load) begin
            data_out <= data_in; // Load new data
        end else if (shift_direction == 0) begin
            data_out <= {data_out[2:0], 1'b0}; // Shift left
        end else begin
            data_out <= {1'b0, data_out[3:1]}; // Shift right
        end
    end
endmodule