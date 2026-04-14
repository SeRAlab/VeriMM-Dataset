module shift_register(
    input clk,
    input reset,
    input load,
    input shift_dir,
    input [7:0] parallel_in,
    output reg [7:0] q
    );
    
    always @(posedge clk) begin
        if (reset)
            q <= 8'b00000000;
        else if (load)
            q <= parallel_in;
        else if (shift_dir)
            q <= {q[6:0], 1'b0};
        else
            q <= {1'b0, q[7:1]};
    end
endmodule