module fixed_priority_arbiter (
    input wire clk,
    input wire rst,
    input wire [3:0] request,
    output reg [1:0] grant,
    output reg grant_valid
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            grant <= 2'b00;
            grant_valid <= 1'b0;
        end else begin
            grant_valid <= 1'b0; // Default
            if (request[0]) begin
                grant <= 2'b00;
                grant_valid <= 1'b1;
            end else if (request[1]) begin
                grant <= 2'b01;
                grant_valid <= 1'b1;
            end else if (request[2]) begin
                grant <= 2'b10;
                grant_valid <= 1'b1;
            end else if (request[3]) begin
                grant <= 2'b11;
                grant_valid <= 1'b1;
            end else begin
                grant <= 2'b00; // Default to grant nothing
            end
        end
    end
endmodule