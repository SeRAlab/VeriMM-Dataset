module top_module(
    input wire d,
    input wire clk,
    input wire sr,
    input wire srval,
    input wire pass_high,
    output wire q
);reg pass_when_high;
    reg pass_when_low;

    always @(*) begin
        if(clk) begin
            pass_when_high <= d;
        end
        if(sr) begin
            pass_when_high <= srval;
        end
    end

    always @(*) begin
        if(!clk) begin
            pass_when_low <= d;
        end
        if(sr) begin
            pass_when_low <= srval;
        end
    end

    assign q = pass_high ? pass_when_high : pass_when_low;

endmodule