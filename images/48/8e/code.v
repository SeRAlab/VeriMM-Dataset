module top_module(
    input CLK,
    input BTN1,
    output LED1
);reg r_LED1 = 1'b0;
reg r_BTN1 = 1'b0;

always @(posedge CLK) begin
    r_BTN1 <= BTN1;

    if (BTN1 == 1'b0 && r_BTN1 == 1'b1)
    begin
        r_LED1 <= ~r_LED1;
    end
end

    assign LED1 = r_LED1;

endmodule