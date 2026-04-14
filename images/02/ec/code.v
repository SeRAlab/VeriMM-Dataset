module dma_controller (
    input clk,
    input rst,
    input [3:0] request,
    output reg [3:0] grant
);
    reg [1:0] state;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= 2'b00;
            grant <= 4'b0000;
        end else begin
            case (state)
                2'b00: begin
                    if (request[0]) begin
                        grant <= 4'b0001;
                        state <= 2'b01;
                    end else if (request[1]) begin
                        grant <= 4'b0010;
                        state <= 2'b10;
                    end else if (request[2]) begin
                        grant <= 4'b0100;
                        state <= 2'b11;
                    end else if (request[3]) begin
                        grant <= 4'b1000;
                        state <= 2'b00;
                    end
                end
                2'b01: begin
                    grant <= 4'b0001;
                    if (!request[0]) state <= 2'b00;
                end
                2'b10: begin
                    grant <= 4'b0010;
                    if (!request[1]) state <= 2'b00;
                end
                2'b11: begin
                    grant <= 4'b0100;
                    if (!request[2]) state <= 2'b00;
                end
            endcase
        end
    end
endmodule