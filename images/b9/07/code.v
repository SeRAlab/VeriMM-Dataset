module top_module(
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    input reset_n,
    input select,
    output reg [99:0] q,
    output reg [5:0] counter_out,
    output reg [99:0] functional_out
);// Define the 100-bit rotator
    reg [99:0] rotator;
    always @ (posedge clk) begin
        if (ena[0]) begin
            rotator <= {rotator[98:0], data[0]};
        end
    end

    // Define the 64-bit Johnson counter
    reg [5:0] johnson_counter;
    always @ (posedge clk) begin
        if (ena[1]) begin
            johnson_counter <= johnson_counter ^ {johnson_counter[5], johnson_counter[4], johnson_counter[3], johnson_counter[2], johnson_counter[1], johnson_counter[0]};
        end
    end

    // Define the functional module for bitwise OR
    always @ (posedge clk) begin
        if (select) begin
            functional_out <= rotator | johnson_counter;
        end else begin
            functional_out <= rotator;
        end
    end

    // Define the output registers
    always @ (posedge clk) begin
        if (load) begin
            q <= data;
            counter_out <= 0;
        end else if (reset_n == 0) begin
            q <= 0;
            counter_out <= 0;
        end else begin
            q <= rotator;
            counter_out <= johnson_counter;
        end
    end

endmodule