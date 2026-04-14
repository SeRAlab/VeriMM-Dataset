module top_module(
    input clk,
    input rst,
    input rxd,
    output reg [7:0] data,      // Change output to reg to allow assignment
    output reg received          // Change output to reg to allow assignment
    );localparam IDLE = 2'b00;
    localparam RECV = 2'b01;
    localparam DONE = 2'b10;

    reg [1:0] state = IDLE;
    reg [7:0] tmp_data = 8'b0;
    reg tmp_received = 1'b0;
    reg [2:0] index;
    reg [1:0] rxd_hist = 2'b11;

    always @(posedge clk or posedge rst)
    begin
        if (rst)
        begin
            tmp_data <= 8'b0;
            tmp_received <= 1'b0;
            rxd_hist <= 2'b11;
            state <= IDLE;
            index <= 3'b000;
        end
        else
        begin
            case(state)
            IDLE:
                if(rxd_hist == 2'b11 && rxd == 1'b0) // Detect start bit
                begin
                    rxd_hist <= 2'b10;
                    state <= RECV;
                    index <= 3'b000;
                end
            RECV:
                begin
                    tmp_data[index] <= rxd; // Use non-blocking assignment
                    index <= index + 1;
                    if (index == 3'b100)
                    begin
                        tmp_received <= 1'b1;
                        state <= DONE;
                    end
                end
            DONE:
                begin
                    received <= tmp_received; // Update received signal
                    data <= tmp_data;         // Assign tmp_data to output
                    tmp_received <= 1'b0;
                    tmp_data <= 8'b0;
                    state <= IDLE;
                end
            endcase

            if (state == IDLE) rxd_hist <= {rxd_hist[0], rxd}; // Update rxd history
        end
    end

endmodule