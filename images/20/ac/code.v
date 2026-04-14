module round_robin_arbiter (
    input clk,
    input rst,
    input [3:0] req,
    output reg [3:0] gnt
);
    reg [1:0] pointer;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            gnt <= 4'b0000;
            pointer <= 2'b00;
        end else begin
            gnt <= 4'b0000; // Clear grant
            case (pointer)
                2'b00: begin
                    if (req[0]) gnt[0] = 1;
                    else if (req[1]) gnt[1] = 1;
                    else if (req[2]) gnt[2] = 1;
                    else if (req[3]) gnt[3] = 1;
                end
                2'b01: begin
                    if (req[1]) gnt[1] = 1;
                    else if (req[2]) gnt[2] = 1;
                    else if (req[3]) gnt[3] = 1;
                    else if (req[0]) gnt[0] = 1;
                end
                2'b10: begin
                    if (req[2]) gnt[2] = 1;
                    else if (req[3]) gnt[3] = 1;
                    else if (req[0]) gnt[0] = 1;
                    else if (req[1]) gnt[1] = 1;
                end
                2'b11: begin
                    if (req[3]) gnt[3] = 1;
                    else if (req[0]) gnt[0] = 1;
                    else if (req[1]) gnt[1] = 1;
                    else if (req[2]) gnt[2] = 1;
                end
            endcase
            pointer <= (gnt == 4'b0000) ? pointer : (pointer + 1) % 4; // Move pointer if no grant
        end
    end
endmodule