module shift_register (
    input wire clk,
    input wire load,
    input wire shift, 
    input wire [3:0] parallel_in,
    output reg [3:0] q
);
    always @(posedge clk) begin
        if (load) begin
            q <= parallel_in; // Load parallel input
        end else if (shift) begin
            q <= {q[2:0], 1'b0}; // Shift left
        end else if (!shift) begin
            q <= {1'b0, q[3:1]}; // Shift right
        end
        // else: Maintain current state
    end
endmodule