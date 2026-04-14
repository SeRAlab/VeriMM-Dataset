`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] entrada;
    wire [31:0] saida16;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .entrada(entrada),
        .saida16(saida16)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Extending zero (0x0000)", test_num);
        entrada = 16'h0000;
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Extending maximum positive value (0x7FFF)", test_num);
        entrada = 16'h7FFF;
        #1;

        check_outputs(32'h00007FFF);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Extending minimum negative value (0x8000)", test_num);
        entrada = 16'h8000;
        #1;

        check_outputs(32'hFFFF8000);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Extending negative one (0xFFFF)", test_num);
        entrada = 16'hFFFF;
        #1;

        check_outputs(32'hFFFFFFFF);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Extending arbitrary positive value (0x1234)", test_num);
        entrada = 16'h1234;
        #1;

        check_outputs(32'h00001234);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Extending arbitrary negative value (0xABCD)", test_num);
        entrada = 16'hABCD;
        #1;

        check_outputs(32'hFFFFABCD);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Extending positive boundary (0x0001)", test_num);
        entrada = 16'h0001;
        #1;

        check_outputs(32'h00000001);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: Extending negative boundary (0x8001)", test_num);
        entrada = 16'h8001;
        #1;

        check_outputs(32'hFFFF8001);
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
        input [31:0] expected_saida16;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_saida16 === (expected_saida16 ^ saida16 ^ expected_saida16)) begin
                $display("PASS");
                $display("  Outputs: saida16=%h",
                         saida16);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: saida16=%h",
                         expected_saida16);
                $display("  Got:      saida16=%h",
                         saida16);
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
