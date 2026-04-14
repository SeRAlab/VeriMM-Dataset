module toggle(
    input clk,
    input reset,
    input in,
    output reg out);

    reg in_d;
    
    always @(posedge clk) begin
        if (reset)
            out <= 1'b0;
        else begin
            in_d <= in;
            if (~in_d & in)
                out <= ~out;
        end
    end
endmodule