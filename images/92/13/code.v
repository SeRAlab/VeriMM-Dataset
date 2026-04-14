module top_module(input wire I_clk,
    input wire I_reset,
    input wire I_enable,
    input wire[15:0] I_in,
    input wire I_write,
    output reg[15:0] O_out);always @(posedge I_clk)
begin: PC
    if (I_reset == 1) begin
        O_out <= 0;
    end
    else if (I_enable == 1)
    begin
        if (I_write == 1)
        begin
            O_out <= I_in;
        end
        else begin
            O_out <= O_out + 2;
        end
    end
end
endmodule