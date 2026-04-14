module ethernet_mac_controller (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output reg [7:0] data_out,
    output reg valid_out
);
    reg [7:0] frame_buffer;
    reg receiving;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            frame_buffer <= 8'b0;
            valid_out <= 1'b0;
            receiving <= 1'b0;
        end else begin
            if (valid_in && !receiving) begin
                frame_buffer <= data_in;
                receiving <= 1'b1;
            end else if (receiving) begin
                data_out <= frame_buffer;
                valid_out <= 1'b1;
                receiving <= 1'b0;
            end else begin
                valid_out <= 1'b0;
            end
        end
    end
endmodule