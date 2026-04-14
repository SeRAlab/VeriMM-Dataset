`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] RG1;
    reg [7:0] RG2;
    reg [7:0] RG3;
    reg listo;
    reg listo_escribe;
    reg listo_lee;
    reg [7:0] seleccion;
    reg [7:0] tecla;
    reg [7:0] tecla2;
    reg [7:0] tecla3;
    wire [7:0] salida_mux_deco;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .RG1(RG1),
        .RG2(RG2),
        .RG3(RG3),
        .listo(listo),
        .listo_escribe(listo_escribe),
        .listo_lee(listo_lee),
        .seleccion(seleccion),
        .tecla(tecla),
        .tecla2(tecla2),
        .tecla3(tecla3),
        .salida_mux_deco(salida_mux_deco)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Selecting tecla", test_num);
            seleccion = 8'd1;
            tecla = 8'h11; tecla2 = 8'h00; tecla3 = 8'h00;
            RG1 = 8'h00; RG2 = 8'h00; RG3 = 8'h00;
            listo = 0; listo_lee = 0; listo_escribe = 0;
            #1;

            check_outputs(8'h11);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Selecting tecla2", test_num);
            seleccion = 8'd2;
            tecla2 = 8'h22;
            #1;

            check_outputs(8'h22);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Selecting tecla3", test_num);
            seleccion = 8'd3;
            tecla3 = 8'h33;
            #1;

            check_outputs(8'h33);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Selecting RG1", test_num);
            seleccion = 8'd4;
            RG1 = 8'h44;
            #1;

            check_outputs(8'h44);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Selecting RG2", test_num);
            seleccion = 8'd5;
            RG2 = 8'h55;
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Selecting RG3", test_num);
            seleccion = 8'd6;
            RG3 = 8'h66;
            #1;

            check_outputs(8'h66);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Selecting listo status", test_num);
            seleccion = 8'd7;
            listo = 1'b1;
            #1;

            check_outputs(8'h01);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: Selecting listo_lee status", test_num);
            seleccion = 8'd8;
            listo_lee = 1'b1;
            #1;

            check_outputs(8'h01);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test %0d: Selecting listo_escribe status", test_num);
            seleccion = 8'd9;
            listo_escribe = 1'b1;
            #1;

            check_outputs(8'h01);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Test %0d: Selecting unexpected value (Default)", test_num);
            seleccion = 8'hFF;
            #1;

            check_outputs(8'h00);
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
        testcase007();
        testcase008();
        testcase009();
        testcase010();
        
        
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
        input [7:0] expected_salida_mux_deco;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_salida_mux_deco === (expected_salida_mux_deco ^ salida_mux_deco ^ expected_salida_mux_deco)) begin
                $display("PASS");
                $display("  Outputs: salida_mux_deco=%h",
                         salida_mux_deco);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: salida_mux_deco=%h",
                         expected_salida_mux_deco);
                $display("  Got:      salida_mux_deco=%h",
                         salida_mux_deco);
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

endmodule
