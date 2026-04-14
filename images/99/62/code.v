module fibonacci_lfsr(
    input clk,
    input rst_n,
    output reg [4:0] q
);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            q <= 5'b00001; // Non-zero seed
        else
            q <= {q[3:0], q[4] ^ q[2]};
    end
    
endmodule