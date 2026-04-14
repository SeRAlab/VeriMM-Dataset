module parallel_load_register(
    input clk,
    input rst_n,
    input load,
    input [7:0] d,
    output reg [7:0] q
);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            q <= 8'b0;
        else if (load)
            q <= d;
    end
    
endmodule