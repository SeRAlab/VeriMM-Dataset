module top_module(
    input clk,
    input reset,
    input [15:0] in,
    output reg [7:0] out_sum);// Split input into two 8-bit outputs using a barrel shifter
    reg [7:0] upper_out;
    reg [7:0] lower_out;
    always @(*) begin
        upper_out = in >> 8;
        lower_out = in & 8'hFF;
    end

    // 4-bit binary counter
    reg [3:0] counter;
    always @(posedge clk) begin
        if (reset) begin
            counter <= 4'h0;
        end else if (counter == 4'hF) begin
            counter <= 4'h0;
        end else begin
            counter <= counter + 1;
        end
    end

    // Adder to sum the two values
    reg [7:0] sum;
    always @(*) begin
        sum = upper_out + counter + lower_out;
    end

    // Output the sum
    always @(posedge clk) begin
        if (reset) begin
            out_sum <= 8'h0;
        end else begin
            out_sum <= sum;
        end
    end

endmodule