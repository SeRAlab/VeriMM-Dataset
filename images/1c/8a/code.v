module ethernet_mac_controller (
    input wire [4:0] data_in,
    input wire control,
    output reg [4:0] data_out,
    output reg transmitted
);

    always @(posedge control) begin
        if (control) begin
            data_out <= data_in;  // Store data_in to data_out
            transmitted <= 1;      // Indicate data has been transmitted
        end else begin
            transmitted <= 0;      // No transmission
        end
    end
endmodule