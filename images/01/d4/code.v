module fixed_priority_arbiter (
    input wire clk,
    input wire reset,
    input wire req0,
    input wire req1,
    input wire req2,
    output reg grant
);
    reg [1:0] state; // 00: None, 01: req0, 10: req1, 11: req2

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            grant <= 0;
            state <= 2'b00;
        end else begin
            case (state)
                2'b00: begin
                    if (req0) begin
                        grant <= 1;
                        state <= 2'b01;
                    end else if (req1) begin
                        grant <= 1;
                        state <= 2'b10;
                    end else if (req2) begin
                        grant <= 1;
                        state <= 2'b11;
                    end
                end
                2'b01: begin // Granted req0
                    if (!req0) begin
                        grant <= 0; // Release grant
                        state <= 2'b00; // Go to idle state
                    end
                end
                2'b10: begin // Granted req1
                    if (!req1) begin
                        grant <= 0; // Release grant
                        state <= 2'b00; // Go to idle state
                    end
                end
                2'b11: begin // Granted req2
                    if (!req2) begin
                        grant <= 0; // Release grant
                        state <= 2'b00; // Go to idle state
                    end
                end
            endcase
        end
    end
endmodule