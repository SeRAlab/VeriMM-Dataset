module top_module(

input [7:0]hours_in,
input [7:0]minutes_in,
input [7:0]seconds_in,
output reg[7:0]hours_out,
output reg[7:0]minutes_out,
output reg[7:0]seconds_out,
output reg PM_LED
    );always @ (*)begin
    if (hours_in == 0) begin
        hours_out = 12;
        minutes_out = minutes_in;
        seconds_out = seconds_in;
        PM_LED = 0;
    end 
    if (hours_in > 0 && hours_in < 12) begin
        hours_out = hours_in;
        minutes_out = minutes_in;
        seconds_out = seconds_in;
        PM_LED = 0;
    end 
    if (hours_in == 12) begin
        hours_out = 12;
        minutes_out = minutes_in;
        seconds_out = seconds_in;
        PM_LED = 1;
    end 
    if (hours_in > 12) begin
        hours_out = hours_in - 12;
        minutes_out = minutes_in;
        seconds_out = seconds_in;
        PM_LED = 1;
    end 
end 
endmodule