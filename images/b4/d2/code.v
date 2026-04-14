module shift_register(
    input clk,
    input reset,
    input shift,
    input d,
    output reg [2:0] q
    );
    
    always @(posedge clk) begin
        if (reset)
            q <= 3'b000;
        else if (shift)
            q <= {q[1:0], d};
    end
endmodule