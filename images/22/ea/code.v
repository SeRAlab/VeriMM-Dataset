module interrupt_controller(  
    input wire clk,  
    input wire reset,  
    input wire [7:0] irq,  
    output reg [2:0] irq_serviced,  
    output reg irq_valid  
);  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            irq_serviced <= 3'b000;  
            irq_valid <= 1'b0;  
        end else begin  
            casez(irq)  
                8'b1??????? : begin irq_serviced <= 3'b000; irq_valid <= 1'b1; end  
                8'b01?????? : begin irq_serviced <= 3'b001; irq_valid <= 1'b1; end  
                8'b001????? : begin irq_serviced <= 3'b010; irq_valid <= 1'b1; end  
                8'b0001???? : begin irq_serviced <= 3'b011; irq_valid <= 1'b1; end  
                8'b00001??? : begin irq_serviced <= 3'b100; irq_valid <= 1'b1; end  
                8'b000001?? : begin irq_serviced <= 3'b101; irq_valid <= 1'b1; end  
                8'b0000001? : begin irq_serviced <= 3'b110; irq_valid <= 1'b1; end  
                8'b00000001 : begin irq_serviced <= 3'b111; irq_valid <= 1'b1; end  
                default : begin irq_serviced <= 3'b000; irq_valid <= 1'b0; end  
            endcase  
        end  
    end  
endmodule