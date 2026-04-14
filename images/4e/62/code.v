module top_module(output reg Q, input C, E, S, D);always @(negedge C) begin
        if (E) begin
            if (S) begin
                Q <= 1;
            end else begin
                Q <= D;
            end
        end
    end
endmodule