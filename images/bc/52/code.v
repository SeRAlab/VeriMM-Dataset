module d_ff(
    input                 clk,
    input                 rst,
    input                 enable,
    input                 d,
    
    output reg            q
);

// D flip-flop implementation
always @(posedge clk) begin
    if (rst) begin
        q <= 1'b0;
    end
    else if (enable) begin
        q <= d;
    end
end

endmodule