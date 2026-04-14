module johnson_counter_8bit (
    input clk,
    input reset,
    output reg [7:0] q
);

always @(posedge clk or posedge reset) begin
    if (reset) 
    begin
        q <= 8'b10000000;
    end 
    else 
    begin
        q <= {q[6:0], ~q[7]};
    end
end

endmodule