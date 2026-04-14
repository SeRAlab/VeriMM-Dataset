module top_module(
    input clk,
    input reset,
    input [7:0] data_in,
    input [1:0] shift_direction,
    input load,
    input slowena,
    output [11:0] output_sum
);reg [7:0] shift_reg;
    reg [3:0] johnson_counter;
    reg [11:0] sum;

    always @(negedge clk or posedge reset) begin
        if (reset) begin
            shift_reg <= 8'b00110100;
            johnson_counter <= 4'b0000;
            sum <= 12'b0;
        end else begin
            if (load) begin
                shift_reg <= data_in;
            end else begin
                if (shift_direction == 2'b00) begin
                    shift_reg <= {shift_reg[6:0], shift_reg[7]};
                end else if (shift_direction == 2'b01) begin
                    shift_reg <= {shift_reg[0], shift_reg[7:1]};
                end
            end

            if (slowena) begin
                johnson_counter <= johnson_counter + 1;
            end
        end
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            sum <= 12'b0;
        end else begin
            sum <= {shift_reg, johnson_counter};
        end
    end

    assign output_sum = sum;

endmodule