`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [6:0] Cuenta_Dia;
    reg [4:0] Cuenta_Horas;
    reg [3:0] Cuenta_Mes;
    reg [5:0] Cuenta_Minutos;
    reg [5:0] Cuenta_Segundos;
    reg [4:0] Cuenta_Year;
    reg [7:0] Estado;
    reg clk;
    wire [7:0] Salida_1;
    wire [7:0] Salida_2;
    wire [7:0] Salida_3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Cuenta_Dia(Cuenta_Dia),
        .Cuenta_Horas(Cuenta_Horas),
        .Cuenta_Mes(Cuenta_Mes),
        .Cuenta_Minutos(Cuenta_Minutos),
        .Cuenta_Segundos(Cuenta_Segundos),
        .Cuenta_Year(Cuenta_Year),
        .Estado(Estado),
        .clk(clk),
        .Salida_1(Salida_1),
        .Salida_2(Salida_2),
        .Salida_3(Salida_3)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            Estado = 8'h00;
            Cuenta_Segundos = 6'd0;
            Cuenta_Minutos = 6'd0;
            Cuenta_Horas = 5'd0;
            Cuenta_Year = 5'd0;
            Cuenta_Mes = 4'd0;
            Cuenta_Dia = 7'd0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Estado 8'h6C", test_num);

            Estado = 8'h6C;
            Cuenta_Segundos = 6'd45;
            Cuenta_Minutos = 6'd30;
            Cuenta_Horas = 5'd12;
            Cuenta_Year = 5'd24;
            Cuenta_Mes = 4'd12;
            Cuenta_Dia = 7'd31;

            @(posedge clk);
            #2;


            #1;



            check_outputs(8'd45, 8'd30, 8'd12);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Estado 8'h75", test_num);

            Estado = 8'h75;
            Cuenta_Segundos = 6'd5;
            Cuenta_Minutos = 6'd10;
            Cuenta_Horas = 5'd2;
            Cuenta_Year = 5'd10;
            Cuenta_Mes = 4'd5;
            Cuenta_Dia = 7'd15;

            @(posedge clk);
            #2;


            #1;



            check_outputs(8'd5, 8'd10, 8'd2);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Other Estado (8'h00)", test_num);

            Estado = 8'h00;
            Cuenta_Segundos = 6'd59;
            Cuenta_Minutos = 6'd59;
            Cuenta_Horas = 5'd23;
            Cuenta_Year = 5'd25;
            Cuenta_Mes = 4'd1;
            Cuenta_Dia = 7'd100;

            @(posedge clk);
            #2;


            #1;



            check_outputs(8'd25, 8'd1, 8'd100);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Other Estado (8'hFF)", test_num);

            Estado = 8'hFF;
            Cuenta_Segundos = 6'd1;
            Cuenta_Minutos = 6'd2;
            Cuenta_Horas = 5'd3;
            Cuenta_Year = 5'd20;
            Cuenta_Mes = 4'd8;
            Cuenta_Dia = 7'd28;

            @(posedge clk);
            #2;


            #1;



            check_outputs(8'd20, 8'd8, 8'd28);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Max Inputs Time (8'h6C)", test_num);

            Estado = 8'h6C;
            Cuenta_Segundos = 6'h3F;
            Cuenta_Minutos = 6'h3F;
            Cuenta_Horas = 5'h1F;
            Cuenta_Year = 5'h00;
            Cuenta_Mes = 4'h0;
            Cuenta_Dia = 7'h00;

            @(posedge clk);
            #2;

            #1;


            check_outputs(8'h3F, 8'h3F, 8'h1F);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Max Inputs Date (Other)", test_num);

            Estado = 8'hAA;
            Cuenta_Segundos = 6'h00;
            Cuenta_Minutos = 6'h00;
            Cuenta_Horas = 5'h00;
            Cuenta_Year = 5'h1F;
            Cuenta_Mes = 4'hF;
            Cuenta_Dia = 7'h7F;

            @(posedge clk);
            #2;

            #1;


            check_outputs(8'h1F, 8'h0F, 8'h7F);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        
        
// Print summary
        $display("\n========================================");
        $display("Test Summary");
        $display("========================================");
        $display("Tests Passed: %0d", pass_count);
        $display("Tests Failed: %0d", fail_count);
        $display("Total Tests:  %0d", pass_count + fail_count);
        $display("========================================");

        if (fail_count == 0)
            $display("ALL TESTS PASSED!");
        else
            $display("SOME TESTS FAILED!");

        $display("\nSimulation completed at time %0t", $time);
        $finish;
    end

    // Task to check outputs
    task check_outputs;
        input [7:0] expected_Salida_1;
        input [7:0] expected_Salida_2;
        input [7:0] expected_Salida_3;
        begin
            if (expected_Salida_1 === (expected_Salida_1 ^ Salida_1 ^ expected_Salida_1) &&
                expected_Salida_2 === (expected_Salida_2 ^ Salida_2 ^ expected_Salida_2) &&
                expected_Salida_3 === (expected_Salida_3 ^ Salida_3 ^ expected_Salida_3)) begin
                $display("PASS");
                $display("  Outputs: Salida_1=%h, Salida_2=%h, Salida_3=%h",
                         Salida_1, Salida_2, Salida_3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Salida_1=%h, Salida_2=%h, Salida_3=%h",
                         expected_Salida_1, expected_Salida_2, expected_Salida_3);
                $display("  Got:      Salida_1=%h, Salida_2=%h, Salida_3=%h",
                         Salida_1, Salida_2, Salida_3);
                fail_count = fail_count + 1;
            end
        end
    endtask

    // Timeout watchdog
    initial begin
        #1000000; // 1ms timeout
        $display("\nERROR: Simulation timeout!");
        $finish;
    end

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,Cuenta_Dia, Cuenta_Horas, Cuenta_Mes, Cuenta_Minutos, Cuenta_Segundos, Cuenta_Year, Estado, clk, Salida_1, Salida_2, Salida_3);
    end

endmodule
