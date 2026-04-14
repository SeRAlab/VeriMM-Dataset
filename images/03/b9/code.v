module round_robin_arbiter (
    input clk,
    input reset,
    input [3:0] request,
    output reg [3:0] grant
);
    reg [1:0] last_grant;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            grant <= 4'b0000;
            last_grant <= 2'b00;
        end else begin
            if (request) begin
                // Round-robin grant logic
                case (last_grant)
                    2'b00: begin
                        if (request[0]) begin
                            grant <= 4'b0001;
                            last_grant <= 2'b00;
                        end else if (request[1]) begin
                            grant <= 4'b0010;
                            last_grant <= 2'b01;
                        end else if (request[2]) begin
                            grant <= 4'b0100;
                            last_grant <= 2'b10;
                        end else if (request[3]) begin
                            grant <= 4'b1000;
                            last_grant <= 2'b11;
                        end else begin
                            grant <= 4'b0000; // no request
                        end
                    end
                    2'b01: begin
                        if (request[1]) begin
                            grant <= 4'b0010;
                            last_grant <= 2'b01;
                        end else if (request[2]) begin
                            grant <= 4'b0100;
                            last_grant <= 2'b10;
                        end else if (request[3]) begin
                            grant <= 4'b1000;
                            last_grant <= 2'b11;
                        end else if (request[0]) begin
                            grant <= 4'b0001;
                            last_grant <= 2'b00;
                        end else begin
                            grant <= 4'b0000; // no request
                        end
                    end
                    2'b10: begin
                        if (request[2]) begin
                            grant <= 4'b0100;
                            last_grant <= 2'b10;
                        end else if (request[3]) begin
                            grant <= 4'b1000;
                            last_grant <= 2'b11;
                        end else if (request[0]) begin
                            grant <= 4'b0001;
                            last_grant <= 2'b00;
                        end else if (request[1]) begin
                            grant <= 4'b0010;
                            last_grant <= 2'b01;
                        end else begin
                            grant <= 4'b0000; // no request
                        end
                    end
                    2'b11: begin
                        if (request[3]) begin
                            grant <= 4'b1000;
                            last_grant <= 2'b11;
                        end else if (request[0]) begin
                            grant <= 4'b0001;
                            last_grant <= 2'b00;
                        end else if (request[1]) begin
                            grant <= 4'b0010;
                            last_grant <= 2'b01;
                        end else if (request[2]) begin
                            grant <= 4'b0100;
                            last_grant <= 2'b10;
                        end else begin
                            grant <= 4'b0000; // no request
                        end
                    end
                endcase
            end else begin
                grant <= 4'b0000; // no request
            end
        end
    end
endmodule