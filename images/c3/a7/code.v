module property_checker(
    input clock,
    input reset,
    input [3:0] data,
    output reg property_met
);

reg [2:0] count;

always @(posedge clock or posedge reset) begin
    if (reset) begin
        count <= 3'b0;
        property_met <= 1'b0;
    end else begin
        if (data == 4'b1100) begin
            count <= count + 1;
        end else begin
            count <= 3'b0;
        end
        
        if (count == 3) begin
            property_met <= 1'b1;
        end else begin
            property_met <= 1'b0;
        end
    end
end

endmodule