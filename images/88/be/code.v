module top_module(input clk, input[7:0] level, output reg tick, input rst);reg[31:0] cycles;
reg[4:0] count;

always @(posedge clk)
begin
    if(cycles < 2000000) 
        cycles <= cycles+1;
    else begin
        cycles <= 0;
        count <= count+5'd1;
    end
    if(count == 5'd25-level) begin 
        count <= 0;
        tick <= 1;
    end
    if(tick)
        tick <= 0;
    if(rst) begin
        tick <= 0;
        count <= 0;
        cycles <= 0;
    end
end

endmodule