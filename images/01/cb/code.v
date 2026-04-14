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
            grant <= 4'b0000; // Default all grants to low
            casez (req)
                4'b1???: grant <= 4'b1000; // Grant to req[3]
                4'b01??: grant <= 4'b0100; // Grant to req[2]
                4'b001?: grant <= 4'b0010; // Grant to req[1]
                4'b0001: grant <= 4'b0001; // Grant to req[0]
                default: grant <= 4'b0000; // No grants
            endcase
        end
    end
endmodule