module pcie_link_training (
    input wire clk,
    input wire reset,
    input wire start_training,
    input wire training_success,
    output reg [1:0] state // 00: IDLE, 01: TRAINING, 10: TRAINED, 11: ERROR
);

    localparam IDLE = 2'b00;
    localparam TRAINING = 2'b01;
    localparam TRAINED = 2'b10;
    localparam ERROR = 2'b11;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    if (start_training) begin
                        state <= TRAINING;
                    end
                end
                TRAINING: begin
                    if (training_success) begin
                        state <= TRAINED;
                    end else begin
                        state <= ERROR;
                    end
                end
                TRAINED: begin
                    // Do nothing, stay in TRAINED
                    state <= TRAINED;
                end
                ERROR: begin
                    // Handle error case or reset
                    state <= IDLE; // Returning to IDLE after error for simplicity
                end
            endcase
        end
    end
endmodule