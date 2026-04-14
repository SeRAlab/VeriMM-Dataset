module counter5bit(
    input clk,
    input reset,
    output reg [4:0] q
    );

    always @(posedge clk)
    begin
        if (reset)
            q <= 5'b0;
        else
            q <= q + 1;
    end
    
endmodule