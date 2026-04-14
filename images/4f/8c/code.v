module top_module(
	input clock,
	input reset,
	input run,
	input counterReset,
	output reg pulse
	);reg [25:0] count;
reg [25:0] countNext;

always @ (posedge clock)
begin
    count <= countNext;
end

always @ (*)
begin
    if(reset || counterReset) 
    begin 
        countNext = 25'd0;
        pulse = 1'b0;
    end
    else if(run)
    begin
    
        if (count == 25'd24_999_999)
        begin
            countNext = 25'b0;
            pulse = 1'b1;
        end
        else
        begin
            
            countNext = count + 1'b1;
            pulse = 25'b0;
        end
    end
    else
    begin
        countNext = count;
        pulse = 1'b0;
    end
end
endmodule