module fixed_priority_arbiter (
    input wire clk,
    input wire rst,
    input wire [3:0] req,
    output reg [3:0] grant
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            grant <= 4'b0000; // reset grant to inactive
        end else begin
            case (req)
                4'b0001: grant <= 4'b0001; // req[0]
                4'b0010: grant <= 4'b0010; // req[1]
                4'b0100: grant <= 4'b0100; // req[2]
                4'b1000: grant <= 4'b1000; // req[3]
                4'b0011: grant <= 4'b0001; // req[0] or req[1] -> grant req[0]
                4'b0110: grant <= 4'b0010; // req[1] or req[2] -> grant req[1]
                4'b1100: grant <= 4'b0100; // req[2] or req[3] -> grant req[2]
                4'b1110: grant <= 4'b0001; // req[0] or req[1] or req[2] -> grant req[0]
                default: grant <= 4'b0000; // no request
            endcase
        end
    end
endmodule