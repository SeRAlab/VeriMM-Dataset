module dma_controller(
    input wire clk,
    input wire reset,
    input wire start_channel1,
    input wire start_channel2,
    output reg [1:0] status // 00: idle, 01: channel 1 active, 10: channel 2 active, 11: both channels active
);
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            status <= 2'b00; // idle state
        end else begin
            case (status)
                2'b00: begin
                    if (start_channel1) begin
                        status <= 2'b01; // channel 1 active
                    end else if (start_channel2) begin
                        status <= 2'b10; // channel 2 active
                    end
                end
                2'b01: begin
                    if (!start_channel1) begin
                        status <= 2'b00; // return to idle
                    end
                end
                2'b10: begin
                    if (!start_channel2) begin
                        status <= 2'b00; // return to idle
                    end
                end
            endcase
        end
    end
endmodule