module fixed_priority_arbiter (
    input wire clk,
    input wire rst_n,
    input wire [2:0] req,
    output reg [2:0] grant
);
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            grant <= 3'b000;
        end else begin
            grant <= 3'b000; // Default no grant
            if (req[2]) begin
                grant <= 3'b100; // Grant req[2]
            end else if (req[1]) begin
                grant <= 3'b010; // Grant req[1]
            end else if (req[0]) begin
                grant <= 3'b001; // Grant req[0]
            end
        end
    end
endmodule