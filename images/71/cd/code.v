module top_module(
    input [3:0] A,
    input load,
    input reset,
    input clk,       // Added clk input
    input shift_dir, // Added shift_dir input
    input [1:0] shift,
    output reg [3:0] Q
);always @(posedge clk) begin
    if (reset) begin
        Q <= 4'b0;
    end else if (load) begin
        Q <= A;
    end else begin
        case (shift)
            2'b00: Q <= Q;
            2'b01: Q <= {Q[2:0], 1'b0}; // Logical left shift
            2'b10: Q <= {1'b0, Q[3:1]}; // Logical right shift
            2'b11: begin
                if (shift_dir) begin
                    Q <= {Q[2:0], Q[3]}; // Rotate left
                end else begin
                    Q <= {Q[0], Q[3:1]}; // Rotate right
                end
            end
        endcase
    end
end

endmodule