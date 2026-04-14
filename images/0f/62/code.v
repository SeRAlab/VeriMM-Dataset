module crc_4bit (
    input clk,
    input reset,
    input [3:0] data_in,
    input [3:0] poly,
    output reg [3:0] crc_out
);
    reg [3:0] remainder;
    reg [3:0] data_reg;
    reg [1:0] state;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            remainder <= 4'b0000;
            crc_out <= 4'b0000;
            state <= 2'b00;
        end else begin
            case (state)
                2'b00: begin
                    data_reg <= data_in;
                    remainder <= 4'b0000;
                    state <= 2'b01;
                end
                2'b01: begin
                    remainder <= data_reg ^ remainder;
                    state <= 2'b10;
                end
                2'b10: begin
                    if (remainder[3]) begin
                        remainder <= {remainder[2:0], 1'b0} ^ poly;
                    end else begin
                        remainder <= {remainder[2:0], 1'b0};
                    end
                    
                    if (data_reg[3:1] != 3'b000) begin
                        data_reg <= {1'b0, data_reg[3:1]};
                    end else begin
                        crc_out <= remainder;
                        state <= 2'b00; // Return to initial state
                    end
                end
            endcase
        end
    end
endmodule