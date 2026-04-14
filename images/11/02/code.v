module dma_controller (
    input clk,
    input rst_n,
    input req1,        // Request from channel 1
    input req2,        // Request from channel 2
    output reg gnt1,   // Grant to channel 1
    output reg gnt2,   // Grant to channel 2
    input [7:0] addr1, // Address for channel 1
    input [7:0] addr2, // Address for channel 2
    input [15:0] data_in1, // Data input for channel 1
    input [15:0] data_in2, // Data input for channel 2
    output reg [15:0] data_out1, // Data output for channel 1
    output reg [15:0] data_out2 // Data output for channel 2
);

    reg [1:0] state; // State machine state
    localparam IDLE = 2'b00,
               CH1_TRANSFER = 2'b01,
               CH2_TRANSFER = 2'b10;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            gnt1 <= 0;
            gnt2 <= 0;
            data_out1 <= 0;
            data_out2 <= 0;
        end else begin
            case (state)
                IDLE: begin
                    gnt1 <= 0;
                    gnt2 <= 0;
                    if (req1) begin
                        gnt1 <= 1;
                        state <= CH1_TRANSFER;
                    end else if (req2) begin
                        gnt2 <= 1;
                        state <= CH2_TRANSFER;
                    end
                end
                CH1_TRANSFER: begin
                    data_out1 <= data_in1; // Transfer data for channel 1
                    gnt1 <= 0; // Release grant
                    state <= IDLE; // Go back to idle
                end
                CH2_TRANSFER: begin
                    data_out2 <= data_in2; // Transfer data for channel 2
                    gnt2 <= 0; // Release grant
                    state <= IDLE; // Go back to idle
                end
            endcase
        end
    end
endmodule