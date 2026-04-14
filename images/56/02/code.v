module reg_with_enable(
    input clk,
    input reset,
    input enable,
    input [3:0] d,
    output reg [3:0] q
    );
    
    always @(posedge clk) begin
        if (reset)
            q <= 4'b0000;
        else if (enable)
            q <= d;
    end
endmodule