module pcie_endpoint_controller (
    input wire clk,
    input wire rst_n,
    input wire [31:0] data_in,
    input wire valid_in,
    output reg [31:0] data_out,
    output reg ready_out
);
    reg [31:0] data_reg;
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_reg <= 32'b0;
            data_out <= 32'b0;
            ready_out <= 1'b0;
        end else if (valid_in) begin
            data_reg <= data_in; // Store incoming data
            ready_out <= 1'b1;    // Indicate ready to output
        end else begin
            ready_out <= 1'b0;    // Not ready unless valid input
        end
    end

    always @(posedge clk) begin
        if (ready_out) begin
            data_out <= data_reg; // Output the stored data
        end
    end
endmodule