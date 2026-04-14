module top_module(input IN1, IN2, IN3, IN4, output Q, input VDD, VSS);wire and_out, or_out;

    assign and_out = IN3 & IN4;
    assign or_out = IN3 | IN4;

    assign Q = (IN1 & ~IN2) ? IN3 :
               (~IN1 & IN2) ? IN4 :
               (IN1 & IN2) ? and_out :
               or_out;
endmodule