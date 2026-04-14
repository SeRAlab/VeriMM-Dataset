module top_module( input [7:0] hours,
                    output reg am_pm,
                    output reg [7:0]twelve_hour_out
    );always@(*)
begin
if (hours > 12) 
    begin
    am_pm <= 1;
    twelve_hour_out <= hours - 12;
    end
if (hours == 12) 
    begin
    am_pm <= 1;
    twelve_hour_out <= hours;
    end    
if ((hours < 12) && (hours > 0)) 
    begin
    am_pm <= 0;
    twelve_hour_out <= hours;
    end
if (hours == 0) 
    begin
    am_pm <= 0;
    twelve_hour_out <= 12;
    end    
end
    

endmodule