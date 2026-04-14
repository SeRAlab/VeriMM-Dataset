module ethernet_mac_controller (
    input wire clk,
    input wire reset,
    input wire [7:0] frame_data,
    input wire frame_valid,
    output reg [15:0] valid_frame_count,
    output reg [15:0] invalid_frame_count
);
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            valid_frame_count <= 16'b0;
            invalid_frame_count <= 16'b0;
        end else begin
            if (frame_valid) begin
                valid_frame_count <= valid_frame_count + 1;
            end else begin
                invalid_frame_count <= invalid_frame_count + 1;
            end
        end
    end
endmodule