module reset_controller (
    input wire reset,
    input wire enable,
    output reg out
);
    always @(posedge enable or posedge reset) begin
        if (reset) begin
            out <= 0;
        end else begin
            out <= 1;
        end
    end
endmodule