module dff_res_set(
    input wire clk,
    input wire rst,
    input wire set,
    input wire d,
    output reg q,
    output reg qn
);

always @ (posedge clk) begin
    if (rst) begin
        q <= 0;
        qn <= 1;
    end else if (set) begin
        q <= 1;
        qn <= 0;
    end else begin
        q <= d;
        qn <= ~d;
    end
end

endmodule