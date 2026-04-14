module dvfs_controller (
    input wire clk,
    input wire reset,
    input wire [2:0] load,
    output reg [2:0] frequency,
    output reg [1:0] voltage
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            frequency <= 3'b000;
            voltage <= 2'b00;
        end else begin
            case (load)
                3'b000: begin
                    frequency <= 3'b000; 
                    voltage <= 2'b00; 
                end
                3'b001: begin
                    frequency <= 3'b001; 
                    voltage <= 2'b01; 
                end
                3'b010: begin
                    frequency <= 3'b010; 
                    voltage <= 2'b01; 
                end
                3'b011: begin
                    frequency <= 3'b011; 
                    voltage <= 2'b10; 
                end
                3'b100: begin
                    frequency <= 3'b100; 
                    voltage <= 2'b10; 
                end
                3'b101: begin
                    frequency <= 3'b101; 
                    voltage <= 2'b11; 
                end
                3'b110: begin
                    frequency <= 3'b110; 
                    voltage <= 2'b11; 
                end
                3'b111: begin
                    frequency <= 3'b111; 
                    voltage <= 2'b11; 
                end
                default: begin
                    frequency <= 3'b000; 
                    voltage <= 2'b00; 
                end
            endcase
        end
    end
endmodule