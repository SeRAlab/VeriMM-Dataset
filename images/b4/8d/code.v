module top_module(
    input wire Clock,
    input wire Reset,
    input wire Up_Down,
    input wire Enable,
    input wire [3:0] Initial,
    output reg [3:0] Q
);always @(posedge Clock) begin
    if (Reset) begin
        Q <= Initial;
    end else if (Enable) begin
        if (Up_Down) begin
            Q <= Q + 1;
        end else begin
            Q <= Q - 1;
        end
    end
end

endmodule