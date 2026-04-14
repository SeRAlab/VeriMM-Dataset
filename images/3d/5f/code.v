module fruit_classifier(  
    input [1:0] color,  
    input [1:0] size,  
    output reg [1:0] fruit  
);  
    always @(*) begin  
        case(color)  
            2'b00: // Red  
                fruit = 2'b00; // Apple  
            2'b01: // Orange  
                fruit = 2'b01; // Orange  
            2'b10: // Yellow  
                case(size)  
                    2'b00: // Small  
                        fruit = 2'b10; // Banana  
                    2'b01: // Medium  
                        fruit = 2'b10; // Banana  
                    2'b10: // Large  
                        fruit = 2'b10; // Banana  
                    default:  
                        fruit = 2'b00; // Default case, Apple  
                endcase  
            default:  
                fruit = 2'b00; // Default case, Apple  
        endcase  
    end  
endmodule