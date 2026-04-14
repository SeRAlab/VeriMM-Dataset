module T_flip_flop (
    input wire T,
    input wire clk,
    input wire reset,
    output reg Q
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        Q <= 0; // Asynchronous reset
    end else if (T) begin
        Q <= ~Q; // Toggle output
    end
end

endmodule