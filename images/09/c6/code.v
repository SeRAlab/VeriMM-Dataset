module SR_latch (
    input wire S,
    input wire R,
    input wire enable,
    output reg Q,
    output reg Qn
);
    
    always @ (S, R, enable) begin
        if (enable) begin
            if (S && !R) begin
                Q <= 1;
                Qn <= 0;
            end else if (!S && R) begin
                Q <= 0;
                Qn <= 1;
            end
        end
    end

endmodule