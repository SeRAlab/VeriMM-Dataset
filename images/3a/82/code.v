module round_robin_arbiter (
    input wire clk,
    input wire reset,
    input wire request0,
    input wire request1,
    input wire request2,
    input wire request3,
    output reg grant0,
    output reg grant1,
    output reg grant2,
    output reg grant3
);
    reg [1:0] last_granted;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            grant0 <= 0;
            grant1 <= 0;
            grant2 <= 0;
            grant3 <= 0;
            last_granted <= 2'b00; // Start from request0
        end else begin
            grant0 <= 0;
            grant1 <= 0;
            grant2 <= 0;
            grant3 <= 0;

            case (last_granted)
                2'b00: begin
                    if (request0) begin
                        grant0 <= 1;
                        last_granted <= 2'b00;
                    end else if (request1) begin
                        grant1 <= 1;
                        last_granted <= 2'b01;
                    end else if (request2) begin
                        grant2 <= 1;
                        last_granted <= 2'b10;
                    end else if (request3) begin
                        grant3 <= 1;
                        last_granted <= 2'b11;
                    end
                end
                2'b01: begin
                    if (request1) begin
                        grant1 <= 1;
                        last_granted <= 2'b01;
                    end else if (request2) begin
                        grant2 <= 1;
                        last_granted <= 2'b10;
                    end else if (request3) begin
                        grant3 <= 1;
                        last_granted <= 2'b11;
                    end else if (request0) begin
                        grant0 <= 1;
                        last_granted <= 2'b00;
                    end
                end
                2'b10: begin
                    if (request2) begin
                        grant2 <= 1;
                        last_granted <= 2'b10;
                    end else if (request3) begin
                        grant3 <= 1;
                        last_granted <= 2'b11;
                    end else if (request0) begin
                        grant0 <= 1;
                        last_granted <= 2'b00;
                    end else if (request1) begin
                        grant1 <= 1;
                        last_granted <= 2'b01;
                    end
                end
                2'b11: begin
                    if (request3) begin
                        grant3 <= 1;
                        last_granted <= 2'b11;
                    end else if (request0) begin
                        grant0 <= 1;
                        last_granted <= 2'b00;
                    end else if (request1) begin
                        grant1 <= 1;
                        last_granted <= 2'b01;
                    end else if (request2) begin
                        grant2 <= 1;
                        last_granted <= 2'b10;
                    end
                end
            endcase
        end
    end
endmodule