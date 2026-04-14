`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg listo;
    reg listo_escribe;
    reg listo_lee;
    reg [7:0] seleccion;
    wire [7:0] salida_mux_deco;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .listo(listo),
        .listo_escribe(listo_escribe),
        .listo_lee(listo_lee),
        .seleccion(seleccion),
        .salida_mux_deco(salida_mux_deco)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Testing selection bit 0 (8'h01)", test_num);
        seleccion = 8'h01;
        listo = 0; listo_lee = 0; listo_escribe = 0;
        #1;

        check_outputs(8'h01);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Testing selection bit 1 (8'h02)", test_num);
        seleccion = 8'h02;
        listo = 0; listo_lee = 0; listo_escribe = 0;
        #1;

        check_outputs(8'h02);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Testing selection bit 2 (8'h04)", test_num);
        seleccion = 8'h04;
        listo = 0; listo_lee = 0; listo_escribe = 0;
        #1;

        check_outputs(8'h04);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Testing selection bit 3 (8'h08)", test_num);
        seleccion = 8'h08;
        listo = 0; listo_lee = 0; listo_escribe = 0;
        #1;

        check_outputs(8'h08);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Testing selection bit 4 with listo=1", test_num);
        seleccion = 8'h10;
        listo = 1; listo_lee = 0; listo_escribe = 0;
        #1;

        check_outputs(8'h01);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Testing selection bit 4 with listo=0", test_num);
        seleccion = 8'h10;
        listo = 0; listo_lee = 0; listo_escribe = 0;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Testing selection bit 5 with listo_lee=1", test_num);
        seleccion = 8'h20;
        listo = 0; listo_lee = 1; listo_escribe = 0;
        #1;

        check_outputs(8'h01);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: Testing selection bit 5 with listo_lee=0", test_num);
        seleccion = 8'h20;
        listo = 0; listo_lee = 0; listo_escribe = 0;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Testcase %0d: Testing selection bit 6 with listo_escribe=1", test_num);
        seleccion = 8'h40;
        listo = 0; listo_lee = 0; listo_escribe = 1;
        #1;

        check_outputs(8'h01);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Testcase %0d: Testing selection bit 6 with listo_escribe=0", test_num);
        seleccion = 8'h40;
        listo = 0; listo_lee = 0; listo_escribe = 0;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase011;

    begin
        test_num = 11;
        $display("Testcase %0d: Testing selection bit 7 (8'h80)", test_num);
        seleccion = 8'h80;
        listo = 1; listo_lee = 1; listo_escribe = 1;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase012;

    begin
        test_num = 12;
        $display("Testcase %0d: Testing no selection bit high (8'h00)", test_num);
        seleccion = 8'h00;
        listo = 1; listo_lee = 1; listo_escribe = 1;
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
        testcase011();
        testcase012();
        
        
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
