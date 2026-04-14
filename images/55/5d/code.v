module register_with_enable(
    input clk,
    input en,
    input [7:0] d,
    output reg [7:0] q
    );
    
    always @(posedge clk) begin
        if (en)
            q <= d;
    end
endmodule