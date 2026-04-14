module johnson_counter_4bit (
    input clk,
    input reset,
    output reg [3:0] q);

always @(posedge clk) begin
    if (reset)
        q <= 4'b0000;
    else
        q <= {~q[0], q[3:1]};
    end
    
endmodule