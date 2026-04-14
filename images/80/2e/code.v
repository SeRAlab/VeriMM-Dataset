module top_module(
    input clk,
    input rst_n,
    input [7:0] data_in,
    input ctrl,
    input valid_a,
    input ready_b,
    output ready_a,
    output reg valid_b,
    output reg [9:0] data_out,
    output reg serial_out
);// Accumulation module
reg [9:0] acc_value;
reg [1:0] acc_state;
reg acc_valid;
wire acc_ready;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        acc_value <= 10'b0;
        acc_state <= 2'b00;
        acc_valid <= 1'b0;
    end else begin
        case (acc_state)
            2'b00: begin // Idle state
                if (valid_a) begin
                    acc_value <= data_in;
                    acc_state <= 2'b01;
                    acc_valid <= 1'b1;
                end
            end
            2'b01: begin // Accumulation state
                if (ctrl) begin
                    acc_value <= acc_value + data_in;
                end
                if (acc_ready) begin
                    acc_state <= 2'b00;
                    acc_valid <= 1'b0;
                end
            end
        endcase
    end
end

assign ready_a = ~acc_valid;
assign acc_ready = ready_b & ~acc_valid;

// Parallel-to-serial conversion module
reg [7:0] shift_reg;
reg [2:0] shift_count;
wire serial_ready;

always @(posedge clk) begin
    if (shift_count == 3'b0) begin
        shift_reg <= acc_value[9:2];
        shift_count <= 3'b1;
        serial_out <= 1'b0;
    end else begin
        shift_reg <= {shift_reg[6:0], acc_value[1]};
        shift_count <= shift_count + 1;
        serial_out <= shift_reg[7];
    end
end

assign valid_b = serial_ready;
assign serial_ready = (shift_count == 3'b0);

// Functional module
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        data_out <= 10'b0;
    end else begin
        data_out <= acc_value + {3'b0, shift_reg};
    end
end

endmodule