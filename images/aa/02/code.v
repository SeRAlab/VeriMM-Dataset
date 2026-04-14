module top_module(
    input clk,
    input reset,
    input enable,
    output [3:0] newTime
    );reg [3:0] clockCounter;
    
    reg [3:0] currTime;

    always @ (posedge enable)
    begin
        currTime <= 0;
        clockCounter <= 0;
    end

    always @ (posedge clk)
    begin
        if (reset == 1'b1)
            begin
                currTime <= 0;
                clockCounter <= 0;
            end
        else if (clockCounter == 100000000 && enable == 1'b1)
            begin
                currTime <= currTime + 1;
                clockCounter <= 1;
            end
        else
            begin
                clockCounter <= clockCounter + 1;
            end
    end

    assign newTime = currTime;

endmodule