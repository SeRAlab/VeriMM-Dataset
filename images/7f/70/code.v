module top_module(
    input reset,
    input clk,
    input sig,
    output sigsync);reg r0 = 0;
    reg r1 = 0;

    
    always @(posedge clk)
    begin
        if (reset)
        begin
            r0 <= 0;
            r1 <= 0;
        end
        else
        begin
            r0 <= sig;
            r1 <= r0;
        end
    end

    assign sigsync = r1;
endmodule