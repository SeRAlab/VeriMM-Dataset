module top_module(
    input wire clock,
    input wire reset,
    input wire sel_1hz,
    input wire clock_1hz,
    input wire sel_10hz,
    input wire clock_10hz,
    input wire sel_100hz,
    input wire clock_100hz,
    input wire sel_1khz,
    input wire clock_1khz,
    input wire sel_10khz,
    input wire clock_10khz,
    input wire sel_100khz,
    input wire clock_100khz,
    input wire sel_1mhz,
    input wire clock_1mhz,
    input wire sel_12mhz,
    input wire clock_12mhz,
    input wire sel_25mhz,
    input wire clock_25mhz,
    output reg clock_saida
);always @ (posedge clock or posedge reset) begin
    if (reset) begin
        clock_saida <= 1'b0;
    end else begin
        case ({sel_25mhz, sel_12mhz, sel_1mhz, sel_100khz, sel_10khz, sel_1khz, sel_100hz, sel_10hz, sel_1hz})
            9'b000000001: clock_saida <= clock_1hz;
            9'b000000010: clock_saida <= clock_10hz;
            9'b000000100: clock_saida <= clock_100hz;
            9'b000001000: clock_saida <= clock_1khz;
            9'b000010000: clock_saida <= clock_10khz;
            9'b000100000: clock_saida <= clock_100khz;
            9'b001000000: clock_saida <= clock_1mhz;
            9'b010000000: clock_saida <= clock_12mhz;
            9'b100000000: clock_saida <= clock_25mhz;
            default: clock_saida <= 1'b0;
        endcase
    end
end

endmodule