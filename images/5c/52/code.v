module top_module(
    din,
    mask,
    dout,
    ndout
);input [7:0] din;
input [7:0] mask;
output reg [7:0] dout;  // Change to output reg
output reg [3:0] ndout; // Change to output reg

reg [7:0] temp;

always @*
begin
    case (mask)
        8'b1111_1111: begin
            ndout = 4'b1000; // Ensure ndout is assigned correctly as a 4-bit value
            dout = din;
        end
        8'b1110_1110: begin
            ndout = 4'b0110; // Ensure ndout is assigned correctly as a 4-bit value
            temp = {din[7:1]};
            dout = {temp, 2'b00};
        end
        8'b1110_0111: begin
            ndout = 4'b0110; // Ensure ndout is assigned correctly as a 4-bit value
            temp = {din[7], din[5:0]};
            dout = {temp, 2'b00};
        end
        8'b1001_1110: begin
            ndout = 4'b0101; // Ensure ndout is assigned correctly as a 4-bit value
            temp = {din[7], din[4:2]};
            dout = {temp, 3'b000};
        end
        8'b0111_1001: begin
            ndout = 4'b0101; // Ensure ndout is assigned correctly as a 4-bit value
            temp = {din[6:4], din[0]};
            dout = {temp, 3'b000};
        end
        default: begin
            ndout = 0;  // Default value for ndout
            dout = 0;   // Default value for dout
        end
    endcase
end

endmodule