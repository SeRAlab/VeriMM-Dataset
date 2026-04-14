module Test_Line (
    input [0:0] address,
    input clock,
    output reg [7:0] q
);

always @(posedge clock) begin
    if (address == 0) begin
        q <= 0;
    end else begin
        q <= {address, 7'b0};
    end
end

endmodule