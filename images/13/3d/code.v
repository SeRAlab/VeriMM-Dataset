module spi_controller (
    input wire clk,
    input wire reset,
    input wire start,
    input wire [7:0] master_data_in,
    output reg [7:0] slave_data_out,
    output reg [7:0] master_data_out,
    output reg data_ready_master,
    output reg data_ready_slave
);

    reg [2:0] state;
    reg [3:0] bit_counter;

    localparam IDLE = 3'b000;
    localparam SEND = 3'b001;
    localparam RECEIVE = 3'b010;
    localparam DONE = 3'b011;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            bit_counter <= 0;
            data_ready_master <= 0;
            data_ready_slave <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (start) begin
                        master_data_out <= master_data_in;
                        bit_counter <= 0;
                        data_ready_master <= 1;
                        state <= SEND;
                    end
                end
                SEND: begin
                    if (bit_counter < 8) begin
                        // Simulate sending data to slave
                        bit_counter <= bit_counter + 1;
                        // On each clock cycle, data can be shifted out
                    end else begin
                        data_ready_master <= 0;
                        state <= RECEIVE;
                    end
                end
                RECEIVE: begin
                    if (bit_counter < 8) begin
                        // Simulate receiving data from slave
                        slave_data_out[bit_counter] <= 1; // Dummy data
                        bit_counter <= bit_counter + 1;
                    end else begin
                        data_ready_slave <= 1;
                        state <= DONE;
                    end
                end
                DONE: begin
                    // Communication done, reset state
                    data_ready_slave <= 0;
                    state <= IDLE;
                end
            endcase
        end
    end
endmodule