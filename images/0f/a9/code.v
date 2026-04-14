module fixed_priority_arbiter (
    input wire clk,
    input wire rst,
    input wire [4:0] req,
    output reg [4:0] grant
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            grant <= 5'b00000;
        end else begin
            grant <= 5'b00000; // Reset grant
            if (req[0]) grant <= 5'b00001;
            else if (req[1]) grant <= 5'b00010;
            else if (req[2]) grant <= 5'b00100;
            else if (req[3]) grant <= 5'b01000;
            else if (req[4]) grant <= 5'b10000;
        end
    end
endmodule