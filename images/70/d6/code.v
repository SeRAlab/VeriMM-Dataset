module top_module(clock, new_clock);input clock;
    output reg new_clock;

    always @ (posedge clock) begin
        new_clock = ~new_clock;
    end
endmodule