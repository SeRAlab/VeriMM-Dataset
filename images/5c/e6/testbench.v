`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] entrada;
    wire [31:0] saida;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .entrada(entrada),
        .saida(saida)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Zero input", test_num);
            entrada = 16'h0000;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: All ones input (Checking for zero extension, not sign extension)", test_num);
            entrada = 16'hFFFF;
            #1;

            check_outputs(32'h0000FFFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: MSB set only", test_num);
            entrada = 16'h8000;
            #1;

            check_outputs(32'h00008000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Alternating bits pattern AAAA", test_num);
            entrada = 16'hAAAA;
            #1;

            check_outputs(32'h0000AAAA);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Alternating bits pattern 5555", test_num);
            entrada = 16'h5555;
            #1;

            check_outputs(32'h00005555);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Arbitrary hex pattern 1234", test_num);
            entrada = 16'h1234;
            #1;

            check_outputs(32'h00001234);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Arbitrary hex pattern FACE", test_num);
            entrada = 16'hFACE;
            #1;

            check_outputs(32'h0000FACE);
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
        input [31:0] expected_saida;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_saida === (expected_saida ^ saida ^ expected_saida)) begin
                $display("PASS");
                $display("  Outputs: saida=%h",
                         saida);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: saida=%h",
                         expected_saida);
                $display("  Got:      saida=%h",
                         saida);
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
