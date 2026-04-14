module top_module(
    input clk,
    input reset,
    input dir,
    input ce,
    input ctrl,
    output reg [3:0] out
);reg [3:0] count;

always @(posedge clk)
begin
    if(reset)
        count <= 4'b0000;
    else if(ce)
    begin
        if(ctrl)
            count <= count + (dir ? -1 : 1);
        else
            count <= count + (dir ? -2 : 2);
    end
end

assign out = count;

endmodule