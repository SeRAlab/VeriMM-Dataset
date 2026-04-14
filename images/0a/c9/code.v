module dma_controller(
    input [3:0] req,
    input ack,
    input clk,
    input rst,
    output reg [1:0] sel,
    output reg active
);
    reg [1:0] state;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            sel <= 2'b00;
            active <= 1'b0;
            state <= 2'b00;
        end else begin
            if (req != 4'b0000) begin
                case (state)
                    2'b00: begin
                        if (req[0]) begin
                            sel <= 2'b00;
                            active <= 1'b1;
                            state <= 2'b01;
                        end else if (req[1]) begin
                            sel <= 2'b01;
                            active <= 1'b1;
                            state <= 2'b01;
                        end else if (req[2]) begin
                            sel <= 2'b10;
                            active <= 1'b1;
                            state <= 2'b01;
                        end else if (req[3]) begin
                            sel <= 2'b11;
                            active <= 1'b1;
                            state <= 2'b01;
                        end
                    end
                    2'b01: begin
                        if (ack) begin
                            active <= 1'b0;
                            state <= 2'b00;
                        end
                    end
                endcase
            end
        end
    end
endmodule