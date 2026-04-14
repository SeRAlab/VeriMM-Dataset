module top_module(
    input clk,      
    input rstn,     

    output green_led    
);reg [ 1:0] green_led_status=1'b0;
 always @(posedge clk)
begin
    if(!rstn)
     green_led_status<=1'b0;
    else 
     green_led_status<=1'b1;
end

    assign green_led = green_led_status;

endmodule