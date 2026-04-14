module fixed_priority_arbiter (
    input wire clk,
    input wire rst,
    input wire [3:0] req,
    output reg [3:0] grant
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        grant <= 4'b0000;
    end else begin
        case (1'b1)
            req[3]: grant <= 4'b1000; // Grant req[3]
            req[2]: grant <= 4'b0100; // Grant req[2]
            req[1]: grant <= 4'b0010; // Grant req[1]
            req[0]: grant <= 4'b0001; // Grant req[0]
            default: grant <= 4'b0000; // No grants
        endcase
    end
end

endmodule