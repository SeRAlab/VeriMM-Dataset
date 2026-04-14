module top_module(
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    input d,
    input reset,
    output reg [3:0] counter_out,
    output reg [31:0] xor_out,
    output reg q
);reg [99:0] rotator_out;
    reg [99:0] shifted_data;
    reg [3:0] counter;
    reg [31:0] xor_data;
    reg [31:0] xor_rotator;

    // Barrel shifter architecture
    always @ (posedge clk) begin
        if (load) begin
            shifted_data <= data;
            rotator_out <= shifted_data;
        end else if (ena[0]) begin
            shifted_data <= {data[98:0], data[99]}; // Rotate right
            rotator_out <= shifted_data;
        end else if (ena[1]) begin
            shifted_data <= {data[0], data[99:1]}; // Rotate left
            rotator_out <= shifted_data;
        end
    end

    // D flip-flop using JK flip-flop and logic gate
    always @ (posedge clk) begin
        if (reset) begin
            q <= 0;
        end else if (load) begin
            q <= d;
        end else begin
            q <= rotator_out[99];
        end
    end

    // 4-bit counter
    always @ (posedge clk) begin
        if (reset) begin
            counter <= 0;
        end else if (ena[0]) begin
            counter <= counter + 1;
        end else if (ena[1]) begin
            counter <= counter - 1;
        end
    end

    // XOR submodule
    always @ (posedge clk) begin
        xor_data <= {data[31:0]} ^ {data[63:32]} ^ {data[95:64]} ^ {data[99:96]};
        xor_rotator <= {rotator_out[31:0]} ^ {rotator_out[63:32]} ^ {rotator_out[95:64]} ^ {rotator_out[99:96]};
        xor_out <= xor_data ^ xor_rotator;
    end

    assign counter_out = counter;

endmodule