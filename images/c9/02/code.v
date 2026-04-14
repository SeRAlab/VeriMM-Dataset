module up_counter_4bit(
    input CLK,
    input RST,
    output reg [3:0] OUT
);

always @(posedge CLK) begin
    if (RST) begin
        OUT <= 4'b0000;
    end else begin
        OUT <= OUT + 1;
    end
end

endmodule