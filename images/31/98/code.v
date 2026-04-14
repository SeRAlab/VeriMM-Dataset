module dma_controller (
    input wire clk,
    input wire reset,
    input wire req0,
    input wire req1,
    input wire req2,
    input wire req3,
    output reg [1:0] grant
);
    reg [1:0] current_channel;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_channel <= 2'b00;
            grant <= 2'b00;
        end else begin
            case (current_channel)
                2'b00: begin
                    if (req0) begin
                        grant <= 2'b00;
                    end else if (req1) begin
                        grant <= 2'b01;
                        current_channel <= 2'b01;
                    end else if (req2) begin
                        grant <= 2'b10;
                        current_channel <= 2'b10;
                    end else if (req3) begin
                        grant <= 2'b11;
                        current_channel <= 2'b11;
                    end
                end
                2'b01: begin
                    if (req1) begin
                        grant <= 2'b01;
                    end else if (req2) begin
                        grant <= 2'b10;
                        current_channel <= 2'b10;
                    end else if (req3) begin
                        grant <= 2'b11;
                        current_channel <= 2'b11;
                    end else if (req0) begin
                        grant <= 2'b00;
                        current_channel <= 2'b00;
                    end
                end
                2'b10: begin
                    if (req2) begin
                        grant <= 2'b10;
                    end else if (req3) begin
                        grant <= 2'b11;
                        current_channel <= 2'b11;
                    end else if (req0) begin
                        grant <= 2'b00;
                        current_channel <= 2'b00;
                    end else if (req1) begin
                        grant <= 2'b01;
                        current_channel <= 2'b01;
                    end
                end
                2'b11: begin
                    if (req3) begin
                        grant <= 2'b11;
                    end else if (req0) begin
                        grant <= 2'b00;
                        current_channel <= 2'b00;
                    end else if (req1) begin
                        grant <= 2'b01;
                        current_channel <= 2'b01;
                    end else if (req2) begin
                        grant <= 2'b10;
                        current_channel <= 2'b10;
                    end
                end
            endcase
            if (grant == 2'b00) current_channel <= 2'b00;
            else if (grant == 2'b01) current_channel <= 2'b01;
            else if (grant == 2'b10) current_channel <= 2'b10;
            else if (grant == 2'b11) current_channel <= 2'b11;
        end
    end
endmodule