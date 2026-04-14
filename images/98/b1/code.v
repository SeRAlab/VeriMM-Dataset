module top_module(output reg Q, input C, E, R, D);always @(negedge C) begin
        if (E) begin
            if (R) begin
                Q <= 0;
            end else begin
                Q <= D;
            end
        end
    end
endmodule