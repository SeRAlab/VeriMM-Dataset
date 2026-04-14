module shift_register (
    input clk,
    input reset,
    input load_en,
    input shift_en,
    input [3:0] data_in,
    output reg [3:0] q
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            q <= 4'b0000; // Reset the register to 0
        end else if (load_en) begin
            q <= data_in; // Load new data
        end else if (shift_en) begin
            q <= {q[2:0], 1'b0}; // Shift left
        end
    end
endmodule