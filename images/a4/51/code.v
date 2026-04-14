module top_module(
    input RST, // Reset maestro
    input CLK, // Reloj maestro 
    input STM, // Iniciar multiplicacion
    output reg [7:0] ENa, // Habilitaciones Ra 
    output reg [7:0] ENb, // Habilitaciones Rb
    output reg [7:0] ENc, // Habilitaciones Rc
    output reg [7:0] SEL, // Selectores Mux
    output reg EOM // Fin de multiplicacion
);reg [2:0] Qp, Qn;

    always @* begin : Combinacional
        case (Qp)
            3'b000: begin // Idle 
                if (STM)
                    Qn = 3'b001;
                else
                    Qn = Qp;
                ENa = 8'b00001111;
                ENb = 8'b00001111;
                ENc = 8'b00000000; 
                SEL = 8'b00000000;
                EOM = 1'b1;
            end
            3'b001: begin 
                Qn  = 3'b010;
                ENa = 8'b11110000;
                ENb = 8'b11110000;
                ENc = 8'b00000000; 
                SEL = 8'b00000000; 
                EOM = 1'b0;
            end
            3'b010: begin 
                Qn  = 3'b011;
                ENa = 8'b01011010;
                ENb = 8'b00000000;
                ENc = 8'b00000000;  
                SEL = 8'b10010101;
                EOM = 1'b0;
            end
            3'b011: begin 
                Qn  = 3'b100;
                ENa = 8'b00000000;
                ENb = 8'b00111100;
                ENc = 8'b00000000; 
                SEL = 8'b01101010;
                EOM = 1'b0;
            end	 
            3'b100: begin 
                Qn  = 3'b000;
                ENa = 8'b00000000;
                ENb = 8'b00000000;
                ENc = 8'b11111111; 	  
                SEL = 8'b01101010;
                EOM = 1'b0;
            end
        endcase
    end

    always @ (posedge RST or posedge CLK) begin : Secuencial
        if (RST)
            Qp <= 0;
        else
            Qp <= Qn;
    end

endmodule