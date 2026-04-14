module shift_register(
    input clk,
    input clr,
    input d,
    
    output reg [2:0] q
);
    always @(posedge clk) begin
        if (clr) begin
            q <= 3'b000;
        end else begin
            q <= {d, q[2:1]};
        end
    end
endmodule