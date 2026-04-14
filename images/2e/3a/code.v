module fixed_priority_arbiter (
    input clk,
    input rst,
    input [3:0] req,
    output reg [3:0] grant
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        grant <= 4'b0000;
    end else begin
        case (1'b1)
            req[0]: grant <= 4'b0001; // Grant to req[0]
            req[1]: grant <= 4'b0010; // Grant to req[1]
            req[2]: grant <= 4'b0100; // Grant to req[2]
            req[3]: grant <= 4'b1000; // Grant to req[3]
            default: grant <= 4'b0000; // No grant
        endcase
    end
end

endmodule