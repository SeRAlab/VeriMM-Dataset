module round_robin_arbiter (
    input clk,
    input rst,
    input [3:0] req,
    output reg [3:0] grant
);
    reg [1:0] last_granted;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            grant <= 4'b0000;
            last_granted <= 2'b00;
        end else begin
            // Find the next request to grant based on last_granted
            case (last_granted)
                2'b00: begin
                    if (req[0]) begin
                        grant <= 4'b0001; last_granted <= 2'b00;
                    end else if (req[1]) begin
                        grant <= 4'b0010; last_granted <= 2'b01;
                    end else if (req[2]) begin
                        grant <= 4'b0100; last_granted <= 2'b10;
                    end else if (req[3]) begin
                        grant <= 4'b1000; last_granted <= 2'b11;
                    end else begin
                        grant <= 4'b0000; last_granted <= 2'b00;
                    end
                end
                2'b01: begin
                    if (req[1]) begin
                        grant <= 4'b0010; last_granted <= 2'b01;
                    end else if (req[2]) begin
                        grant <= 4'b0100; last_granted <= 2'b10;
                    end else if (req[3]) begin
                        grant <= 4'b1000; last_granted <= 2'b11;
                    end else if (req[0]) begin
                        grant <= 4'b0001; last_granted <= 2'b00;
                    end else begin
                        grant <= 4'b0000; last_granted <= 2'b01;
                    end
                end
                2'b10: begin
                    if (req[2]) begin
                        grant <= 4'b0100; last_granted <= 2'b10;
                    end else if (req[3]) begin
                        grant <= 4'b1000; last_granted <= 2'b11;
                    end else if (req[0]) begin
                        grant <= 4'b0001; last_granted <= 2'b00;
                    end else if (req[1]) begin
                        grant <= 4'b0010; last_granted <= 2'b01;
                    end else begin
                        grant <= 4'b0000; last_granted <= 2'b10;
                    end
                end
                2'b11: begin
                    if (req[3]) begin
                        grant <= 4'b1000; last_granted <= 2'b11;
                    end else if (req[0]) begin
                        grant <= 4'b0001; last_granted <= 2'b00;
                    end else if (req[1]) begin
                        grant <= 4'b0010; last_granted <= 2'b01;
                    end else if (req[2]) begin
                        grant <= 4'b0100; last_granted <= 2'b10;
                    end else begin
                        grant <= 4'b0000; last_granted <= 2'b11;
                    end
                end
            endcase
        end
    end
endmodule