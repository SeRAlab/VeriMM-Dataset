module pcie_endpoint_controller (
    input wire clk,
    input wire reset,
    input wire read_request,
    input wire write_request,
    input wire [31:0] data_in,
    output reg read_ready,
    output reg write_ready,
    output reg [31:0] data_out
);
    
    reg [31:0] data_buffer;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            read_ready <= 0;
            write_ready <= 0;
            data_out <= 0;
            data_buffer <= 0;
        end else begin
            if (write_request) begin
                data_buffer <= data_in; // Store incoming data
                write_ready <= 1; // Indicate write is ready
            end else begin
                write_ready <= 0;
            end

            if (read_request) begin
                data_out <= data_buffer; // Provide data on read request
                read_ready <= 1; // Indicate read is ready
            end else begin
                read_ready <= 0;
            end
        end
    end
endmodule