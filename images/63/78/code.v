module top_module(input D, input C, input E, input R, output reg Q);always @(posedge C or posedge R) begin
    if (R) begin
        Q <= 1'b0;
    end else if (E) begin
        Q <= D;
    end
end

endmodule