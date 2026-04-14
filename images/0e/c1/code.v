module pcie_endpoint (
    input wire clk,
    input wire reset,
    input wire [31:0] data_in,
    input wire data_in_valid,
    output reg [31:0] data_out,
    output reg data_out_valid
);
    reg [31:0] data_reg;
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            data_reg <= 32'd0;
            data_out <= 32'd0;
            data_out_valid <= 1'b0;
        end else begin
            if (data_in_valid) begin
                data_reg <= data_in; // Store incoming data
                data_out_valid <= 1'b1; // Indicate data is ready to send
            end
            
            if (data_out_valid) begin
                data_out <= data_reg; // Transmit stored data
                data_out_valid <= 1'b0; // Reset output valid signal
            end
        end
    end
endmodule