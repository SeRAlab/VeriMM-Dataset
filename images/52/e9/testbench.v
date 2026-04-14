`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg clock;
    reg contar;
    reg funcao;
    reg parar;
    reg pausar;
    reg reset;
    wire [3:0] saida0;
    wire [3:0] saida1;
    wire [3:0] saida2;
    wire [3:0] saida3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .contar(contar),
        .funcao(funcao),
        .parar(parar),
        .pausar(pausar),
        .reset(reset),
        .saida0(saida0),
        .saida1(saida1),
        .saida2(saida2),
        .saida3(saida3)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Reset Logic", test_num);

            reset = 1; contar = 0; parar = 0; pausar = 0; funcao = 0;
            @(posedge clock);
            #1 reset = 0;
            @(posedge clock);

            #1;


            check_outputs(4'h0, 4'h0, 4'h0, 4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Transition to CONTANDO", test_num);
            reset = 1; #10 reset = 0;
            @(posedge clock);
            contar = 1;
            repeat(5) @(posedge clock);
            #1;

            #1;


            check_outputs(4'h5, 4'h0, 4'h0, 4'h0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Transition to PAUSADO", test_num);
            reset = 1; #10 reset = 0;
            contar = 1;
            repeat(3) @(posedge clock);
            contar = 0; pausar = 1;
            repeat(3) @(posedge clock);
            #1;

            #1;


            check_outputs(4'h3, 4'h0, 4'h0, 4'h0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Resume from PAUSADO", test_num);
            reset = 1; #10 reset = 0;
            contar = 1;
            repeat(2) @(posedge clock);
            pausar = 1; @(posedge clock);
            pausar = 0; contar = 1;
            repeat(2) @(posedge clock);
            #1;

            #1;


            check_outputs(4'h4, 4'h0, 4'h0, 4'h0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Transition to PARADO", test_num);
            reset = 1; #10 reset = 0;
            contar = 1;
            repeat(4) @(posedge clock);
            parar = 1; @(posedge clock);
            contar = 1;
            repeat(2) @(posedge clock);
            #1;


            #1;



            check_outputs(4'h4, 4'h0, 4'h0, 4'h0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Multi-digit Carry", test_num);
            reset = 1; #10 reset = 0;
            contar = 1;
            repeat(12) @(posedge clock);
            #1;

            #1;


            check_outputs(4'h2, 4'h1, 4'h0, 4'h0);
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
        input [3:0] expected_saida0;
        input [3:0] expected_saida1;
        input [3:0] expected_saida2;
        input [3:0] expected_saida3;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_saida0 === (expected_saida0 ^ saida0 ^ expected_saida0) &&
                expected_saida1 === (expected_saida1 ^ saida1 ^ expected_saida1) &&
                expected_saida2 === (expected_saida2 ^ saida2 ^ expected_saida2) &&
                expected_saida3 === (expected_saida3 ^ saida3 ^ expected_saida3)) begin
                $display("PASS");
                $display("  Outputs: saida0=%h, saida1=%h, saida2=%h, saida3=%h",
                         saida0, saida1, saida2, saida3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: saida0=%h, saida1=%h, saida2=%h, saida3=%h",
                         expected_saida0, expected_saida1, expected_saida2, expected_saida3);
                $display("  Got:      saida0=%h, saida1=%h, saida2=%h, saida3=%h",
                         saida0, saida1, saida2, saida3);
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
