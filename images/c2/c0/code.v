module binary_counter (
    input clk,
    input rst,
    output reg Q1,
    output reg Q0
);

    reg D1, D0;

    always @ (posedge clk or negedge rst) begin
        if (!rst) begin
            D1 <= 1'b0;
            D0 <= 1'b0;
        end else begin
            D1 <= Q0;
            D0 <= ~Q0;
        end
    end

    assign Q1 = D1;
    assign Q0 = D0;

endmodule