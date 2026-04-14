module PISO (
    input wire clk,
    input wire load,
    input wire [7:0] parallel_in,
    output reg serial_out,
    output reg ready
);
    reg [7:0] shift_reg;
    integer count;

    always @(posedge clk) begin
        if (load) begin
            shift_reg <= parallel_in;
            count <= 7;  // Load the full input
            ready <= 1;  // Indicate that data is ready to be shifted out
        end else if (ready) begin
            serial_out <= shift_reg[count]; // Shift out the most significant bit first
            if (count == 0) begin
                ready <= 0; // Finished shifting out
            end else begin
                count <= count - 1; // Move to the next bit
            end
        end
    end
endmodule