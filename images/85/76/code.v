module register_8bit(
    input clk,
    input enable,
    input [7:0] d,
    output reg [7:0] q
    );
    
    always @(posedge clk) begin
        if (!enable)
            q <= 8'b0;
        else
            q <= d;
    end
endmodule