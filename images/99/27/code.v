module top_module(clk, reset, mode, fph, word, phase);parameter M = 48;
    parameter N = 14;

    input clk, reset, fph;
    input [1:0] mode;
    inout [M-1:0] word;
    output [N-1:0] phase;

    reg [M-1:0] freq, acc;

    assign phase = acc[M-1:M-N];
    assign word  = mode == 2'b10 ? (fph ? freq : acc) : 'bz;

    always @ (posedge clk, posedge reset)
    begin
        if (reset) begin
            freq  <= 'b0;
            acc   <= 'b0;
        end
        else begin
            if (!mode)
                acc <= acc + freq;
            else if (mode == 2'b11) begin
                if (fph)
                    freq <= word;
                else
                    acc  <= word;
            end
        end
    end

endmodule