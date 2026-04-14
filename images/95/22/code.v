module top_module(
    input A0,
    input A1,
    input S,
    input rst,
    output reg X
);always @ (posedge rst, posedge S) begin
    if (rst) begin
        X <= 1'b0;
    end else begin
        if (S) begin
            X <= A1;
        end else begin
            X <= A0;
        end
    end
end

endmodule