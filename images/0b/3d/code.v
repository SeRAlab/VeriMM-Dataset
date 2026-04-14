module shift_register (
    input wire clk,
    input wire load,
    input wire shift_left,
    input wire [3:0] parallel_in,
    output reg [3:0] Q
);
    always @(posedge clk) begin
        if (load) begin
            Q <= parallel_in; // Load parallel input
        end else if (shift_left) begin
            Q <= {Q[2:0], 1'b0}; // Shift left
        end else begin
            Q <= {1'b0, Q[3:1]}; // Shift right
        end
    end
endmodule