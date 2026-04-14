module shift_reg16(
    input [15:0] d,
    input clk,
    input load,
    input shift,
    output reg [15:0] q
    );

    always @(posedge clk)
    begin
        if (load)
            q <= d;
        else if (shift)
            q <= {1'b0, q[15:1]};
    end
    
endmodule