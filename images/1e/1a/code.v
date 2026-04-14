module round_robin_arbiter (
    input wire clk,
    input wire reset,
    input wire req0,
    input wire req1,
    input wire req2,
    input wire req3,
    output reg [3:0] grant
);
    reg [1:0] last_granted;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            grant <= 4'b0000;
            last_granted <= 2'b00;
        end else begin
            case (last_granted)
                2'b00: begin
                    if (req0) begin
                        grant <= 4'b0001;
                        last_granted <= 2'b00;
                    end else if (req1) begin
                        grant <= 4'b0010;
                        last_granted <= 2'b01;
                    end else if (req2) begin
                        grant <= 4'b0100;
                        last_granted <= 2'b10;
                    end else if (req3) begin
                        grant <= 4'b1000;
                        last_granted <= 2'b11;
                    end else begin
                        grant <= 4'b0000;
                    end
                end
                2'b01: begin
                    if (req1) begin
                        grant <= 4'b0010;
                        last_granted <= 2'b01;
                    end else if (req2) begin
                        grant <= 4'b0100;
                        last_granted <= 2'b10;
                    end else if (req3) begin
                        grant <= 4'b1000;
                        last_granted <= 2'b11;
                    end else if (req0) begin
                        grant <= 4'b0001;
                        last_granted <= 2'b00;
                    end else begin
                        grant <= 4'b0000;
                    end
                end
                2'b10: begin
                    if (req2) begin
                        grant <= 4'b0100;
                        last_granted <= 2'b10;
                    end else if (req3) begin
                        grant <= 4'b1000;
                        last_granted <= 2'b11;
                    end else if (req0) begin
                        grant <= 4'b0001;
                        last_granted <= 2'b00;
                    end else if (req1) begin
                        grant <= 4'b0010;
                        last_granted <= 2'b01;
                    end else begin
                        grant <= 4'b0000;
                    end
                end
                2'b11: begin
                    if (req3) begin
                        grant <= 4'b1000;
                        last_granted <= 2'b11;
                    end else if (req0) begin
                        grant <= 4'b0001;
                        last_granted <= 2'b00;
                    end else if (req1) begin
                        grant <= 4'b0010;
                        last_granted <= 2'b01;
                    end else if (req2) begin
                        grant <= 4'b0100;
                        last_granted <= 2'b10;
                    end else begin
                        grant <= 4'b0000;
                    end
                end
                default: grant <= 4'b0000;
            endcase
        end
    end
endmodule