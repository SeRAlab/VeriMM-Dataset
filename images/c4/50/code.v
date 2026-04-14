module debounce(input clk, but, output reg debounced);
    reg [9:0] debTimer;
    always @(posedge clk) begin
        if (debounced == but) // button is stable
            debTimer <= 0;
        else if (debTimer != 10'd9) // button is bouncing
            debTimer <= debTimer + 1;
        else if (debTimer == 10'd9) // button has been stable for 10 cycles
            debounced <= but;
    end
endmodule