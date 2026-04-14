module fixed_priority_arbiter(
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
                req[0]: grant <= 4'b0001; // Grant highest priority
                req[1]: grant <= 4'b0010; // Grant second priority
                req[2]: grant <= 4'b0100; // Grant third priority
                req[3]: grant <= 4'b1000; // Grant lowest priority
                default: grant <= 4'b0000; // No requests
            endcase
        end
    end
endmodule