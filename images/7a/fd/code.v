module top_module(
    output reg Y,  // Change from output to output reg
    input A1,
    input A2,
    input B1,
    input VPWR
);always @(*) begin
        if (A1 && A2) begin
            Y = 1'b1;
        end else if (A1 && !A2) begin
            Y = B1;
        end else if (!A1 && A2) begin
            Y = VPWR;
        end else begin
            Y = 1'b0;
        end
    end

endmodule