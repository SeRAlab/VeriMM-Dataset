module top_module(
    input SW_0,
    input SW_1,
    input SW_2,
    input SW_3,
    output LED_0,
    output LED_1,
    output LED_2,
    output LED_3
);reg LED_0_state;
reg LED_1_state;
reg LED_2_state;
reg LED_3_state;

always @(*) begin
    if (SW_0 == 0) LED_0_state = 1;
    else LED_0_state = 0;
    
    if (SW_1 == 0) LED_1_state = 1;
    else LED_1_state = 0;
    
    if (SW_2 == 0) LED_2_state = 1;
    else LED_2_state = 0;
    
    if (SW_3 == 0) LED_3_state = 1;
    else LED_3_state = 0;
end

assign LED_0 = LED_0_state;
assign LED_1 = LED_1_state;
assign LED_2 = LED_2_state;
assign LED_3 = LED_3_state;

endmodule