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
            case (req)
                4'b0000: grant <= 4'b0000; // No requests
                4'b0001: grant <= 4'b0001; // Highest priority
                4'b0010: grant <= (req[0] ? 4'b0001 : 4'b0010); // req[1] if req[0] is not present
                4'b0100: grant <= (req[1] | req[0] ? 4'b0001 : 4'b0100); // req[2] if req[0] or req[1] is not present
                4'b1000: grant <= (req[2] | req[1] | req[0] ? 4'b0001 : 4'b1000); // req[3]
                default: grant <= 4'b0000; // Default case
            endcase
        end
    end
endmodule