module binary_up_counter(
    input clk,
    input rst_n,
    output reg [2:0] q
);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            q <= 3'b0;
        else
            q <= q + 1;
    end
    
endmodule