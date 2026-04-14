module round_robin_arbiter (
    input clk,
    input rst,
    input [3:0] req,
    output reg [3:0] grant
);

    reg [1:0] last_granted; // Keeps track of the last granted requester

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            grant <= 4'b0000;
            last_granted <= 2'b00;
        end else begin
            // If there's a request, grant to the next requester
            if (|req) begin
                // Grant the next requester in a round-robin fashion
                if (last_granted == 2'b11)
                    last_granted <= 2'b00;
                else
                    last_granted <= last_granted + 1;

                // Assign grant based on last_granted
                case (last_granted)
                    2'b00: grant <= (req[0]) ? 4'b0001 : 4'b0000;
                    2'b01: grant <= (req[1]) ? 4'b0010 : 4'b0000;
                    2'b10: grant <= (req[2]) ? 4'b0100 : 4'b0000;
                    2'b11: grant <= (req[3]) ? 4'b1000 : 4'b0000;
                    default: grant <= 4'b0000;
                endcase
            end
        end
    end
endmodule