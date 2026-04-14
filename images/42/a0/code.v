module top_module(input  reset,
                input  clear,
                input  clk,
                input  pia_e,
                output reg pia_ca1, pia_cb1,
                input  pia_ca2, pia_cb2,
                output reg [6:0] pia_pa,
                input  [6:0] pia_pb,
                output pia_da,
                input  fifo_rxf, fifo_txe,
                output reg fifo_rd, fifo_wr,
                inout  [7:0] fifo_data);localparam STATE_READ_SETUP       = 3'b000;
    localparam STATE_READ_STROBE_LOW   = 3'b001;
    localparam STATE_READ_STROBE_HIGH  = 3'b010;
    localparam STATE_WRITE_SETUP       = 3'b100;
    localparam STATE_WRITE_STROBE_LOW  = 3'b101;
    localparam STATE_WRITE_STROBE_HIGH = 3'b110;

    localparam STATE_WRITE_MASK = 3'b100;  // Corrected the SIZE (consistent with other states)

    reg [7:0] fifo_data_out;
    reg [2:0] state;

    always @(posedge clk) begin
        if (!reset) begin
            pia_ca1 <= 1'b0;
            pia_cb1 <= 1'b0;
            fifo_rd <= 1'b1;
            fifo_wr <= 1'b1;
            state <= STATE_READ_SETUP;
        end
        else if (!pia_e) begin
            pia_ca1 <= !fifo_rxf;
            pia_cb1 <= !fifo_txe;
            state <= STATE_READ_STROBE_LOW;
        end
        else begin
            case (state)
                STATE_READ_STROBE_LOW: begin
                    if (pia_ca2) begin
                        fifo_rd <= 1'b0;
                    end
                    state <= STATE_READ_STROBE_HIGH;
                end

                STATE_READ_STROBE_HIGH: begin
                    if (pia_ca2) begin
                        pia_pa <= fifo_data[6:0];
                        fifo_rd <= 1'b1;
                        pia_ca1 <= 1'b0;
                    end
                    state <= STATE_WRITE_SETUP;
                end

                STATE_WRITE_SETUP: begin
                    if (pia_cb2) begin
                        fifo_data_out <= {1'b0, pia_pb[6:0]};  // Changed 0'b0 to 1'b0 for the MSB
                    end
                    state <= STATE_WRITE_STROBE_LOW;
                end

                STATE_WRITE_STROBE_LOW: begin
                    if (pia_cb2) begin
                        fifo_wr <= 1'b0;
                    end
                    state <= STATE_WRITE_STROBE_HIGH;
                end

                STATE_WRITE_STROBE_HIGH: begin
                    if (pia_cb2) begin
                        fifo_wr <= 1'b1;
                        pia_cb1 <= 1'b0; // Moved outside the 'if'. No need to check pia_cb2 again.
                    end
                    state <= STATE_READ_SETUP;
                end
            endcase
        end
    end

    assign pia_da = !pia_cb2 || fifo_txe;
    assign fifo_data = (state & STATE_WRITE_MASK) ? fifo_data_out : 8'bz;
endmodule