module gpio_controller(
    input wire clk,
    input wire rst_n,
    input wire we,         // Write enable
    input wire [4:0] din, // Data input (5-bit)
    input wire rdy,       // Ready signal to read input
    output reg [4:0] dout, // Data output (5-bit)
    output reg [4:0] gpio_in // GPIO input (5-bit)
);
    reg [4:0] gpio_out; // GPIO output register

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            gpio_out <= 5'b0;
            dout <= 5'b0;
            gpio_in <= 5'b0;
        end else begin
            if (we) begin
                gpio_out <= din; // Update output register
            end
            dout <= gpio_out; // Output the current state of the output register
            
            if (rdy) begin
                gpio_in <= gpio_out; // Read from output to input register
            end
        end
    end
endmodule