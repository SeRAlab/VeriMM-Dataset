module sync_counter (
    input CLK,
    input RST,
    input EN,
    output reg [3:0] Q
);

always @(posedge CLK) begin
    if (RST) begin
        Q <= 4'b0000;
    end else if (EN) begin
        Q <= Q + 1;
    end
end

endmodule