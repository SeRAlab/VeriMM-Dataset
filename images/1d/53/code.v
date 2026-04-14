module crystal_oscillator (
    input wire clock,
    input wire [3:0] div_factor,
    output reg out_signal
);
    reg [3:0] counter;

    always @(posedge clock) begin
        if (counter == div_factor) begin
            out_signal <= ~out_signal;
            counter <= 0;
        end else begin
            counter <= counter + 1;
        end
    end
endmodule