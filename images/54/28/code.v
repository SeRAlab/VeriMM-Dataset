module shift_register(
    input clk,
    input reset,
    input load,
    input [3:0] parallel_in,
    input shift_left,
    output reg [3:0] q
    );
    
    always @(posedge clk or posedge reset) begin
        if (reset)
            q <= 4'b0000;
        else if (load)
            q <= parallel_in;
        else if (shift_left)
            q <= {q[2:0], 1'b0};
        else
            q <= {1'b0, q[3:1]};
    end
endmodule