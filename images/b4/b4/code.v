module top_module(
    inclk0,
    c0,
    c1
);input   inclk0;
output  reg c0;  // Changed from wire to reg
output  reg c1;  // Changed from wire to reg

reg     [1:0] counter;

always @(posedge inclk0) begin
    counter <= counter + 1;
    if (counter == 2'b00) begin
        c0 <= ~c0;
    end
    if (counter == 2'b01) begin
        c1 <= ~c1;
    end
end

endmodule