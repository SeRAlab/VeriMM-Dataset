module fixed_priority_arbiter (
    input wire clk,
    input wire reset,
    input wire [3:0] req,
    output reg [3:0] grant
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        grant <= 4'b0000;
    end else begin
        grant <= 4'b0000; // Default to no grant
        casez (req)
            4'b1???: grant <= 4'b1000; // grant req[0]
            4'b01??: grant <= 4'b0100; // grant req[1]
            4'b001?: grant <= 4'b0010; // grant req[2]
            4'b0001: grant <= 4'b0001; // grant req[3]
        endcase
    end
end

endmodule