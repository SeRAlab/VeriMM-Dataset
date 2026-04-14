module mux_2to1 (output reg out, input in0, in1, sel);
    always @ (sel) begin
        if (sel == 0) begin
            out <= in0;
        end
        else begin
            out <= in1;
        end
    end
endmodule