module shift_register_4bit(
    input clk,
    input load,
    input [3:0] data,
    output reg [3:0] q);
    
    always @(posedge clk) begin
        if (load)
            q <= data; // Parallel load
        else
            q <= {q[2:0], 1'b0}; // Shift right
    end
endmodule