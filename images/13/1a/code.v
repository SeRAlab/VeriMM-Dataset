module round_robin_arbiter(
    input clk,
    input reset,
    input [3:0] request,
    output reg [3:0] grant
);
    reg [1:0] last_granted;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            grant <= 4'b0000;
            last_granted <= 2'b00;
        end else begin
            // Determine the next grant based on the last granted source
            case (last_granted)
                2'b00: begin
                    if (request[0]) begin
                        grant <= 4'b0001; // Grant to source 0
                        last_granted <= 2'b00;
                    end else if (request[1]) begin
                        grant <= 4'b0010; // Grant to source 1
                        last_granted <= 2'b01;
                    end else if (request[2]) begin
                        grant <= 4'b0100; // Grant to source 2
                        last_granted <= 2'b10;
                    end else if (request[3]) begin
                        grant <= 4'b1000; // Grant to source 3
                        last_granted <= 2'b11;
                    end else begin
                        grant <= 4'b0000; // No request
                    end
                end
                2'b01: begin
                    if (request[1]) begin
                        grant <= 4'b0010; // Grant to source 1
                        last_granted <= 2'b01;
                    end else if (request[2]) begin
                        grant <= 4'b0100; // Grant to source 2
                        last_granted <= 2'b10;
                    end else if (request[3]) begin
                        grant <= 4'b1000; // Grant to source 3
                        last_granted <= 2'b11;
                    end else if (request[0]) begin
                        grant <= 4'b0001; // Grant to source 0
                        last_granted <= 2'b00;
                    end else begin
                        grant <= 4'b0000; // No request
                    end
                end
                2'b10: begin
                    if (request[2]) begin
                        grant <= 4'b0100; // Grant to source 2
                        last_granted <= 2'b10;
                    end else if (request[3]) begin
                        grant <= 4'b1000; // Grant to source 3
                        last_granted <= 2'b11;
                    end else if (request[0]) begin
                        grant <= 4'b0001; // Grant to source 0
                        last_granted <= 2'b00;
                    end else if (request[1]) begin
                        grant <= 4'b0010; // Grant to source 1
                        last_granted <= 2'b01;
                    end else begin
                        grant <= 4'b0000; // No request
                    end
                end
                2'b11: begin
                    if (request[3]) begin
                        grant <= 4'b1000; // Grant to source 3
                        last_granted <= 2'b11;
                    end else if (request[0]) begin
                        grant <= 4'b0001; // Grant to source 0
                        last_granted <= 2'b00;
                    end else if (request[1]) begin
                        grant <= 4'b0010; // Grant to source 1
                        last_granted <= 2'b01;
                    end else if (request[2]) begin
                        grant <= 4'b0100; // Grant to source 2
                        last_granted <= 2'b10;
                    end else begin
                        grant <= 4'b0000; // No request
                    end
                end
            endcase
        end
    end
endmodule