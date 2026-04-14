module top_module(
    input clk,
    input reset,
    input [24:0] in_data,
    input [8:0] kernel,
    output [8:0] out_data,
    output valid
);reg [24:0] input_buffer [0:4];
    reg [8:0] kernel_buffer [0:8];
    reg [8:0] output_buffer;
    reg valid_buffer;
    integer i, j;

    always @(posedge clk) begin
        if (reset) begin
            output_buffer <= 0;
            valid_buffer <= 0;
            for (i = 0; i < 5; i = i + 1) begin
                input_buffer[i] <= 0;
                if (i < 3) begin
                    kernel_buffer[i] <= 0;
                end
            end
        end else if (!valid_buffer) begin
            for (i = 3; i > 0; i = i - 1) begin
                input_buffer[i] <= input_buffer[i-1];
                if (i < 3) begin
                    kernel_buffer[i] <= kernel_buffer[i-1];
                end
            end
            input_buffer[0] <= in_data;
            kernel_buffer[0] <= kernel;
            if (input_buffer[2][4] && kernel_buffer[2][2]) begin
                output_buffer <= output_buffer + input_buffer[0][4]*kernel_buffer[0][0] +
                                                input_buffer[0][3]*kernel_buffer[0][1] +
                                                input_buffer[0][2]*kernel_buffer[0][2] +
                                                input_buffer[1][4]*kernel_buffer[1][0] +
                                                input_buffer[1][3]*kernel_buffer[1][1] +
                                                input_buffer[1][2]*kernel_buffer[1][2] +
                                                input_buffer[2][4]*kernel_buffer[2][0] +
                                                input_buffer[2][3]*kernel_buffer[2][1] +
                                                input_buffer[2][2]*kernel_buffer[2][2];
                valid_buffer <= 1;
            end
        end else begin
            valid_buffer <= 0;
        end

    end

    assign out_data = output_buffer;
    assign valid = valid_buffer;

endmodule