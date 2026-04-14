`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [25:0] instructionIn25_0;
    wire [27:0] instructionOut27_0;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .instructionIn25_0(instructionIn25_0),
        .instructionOut27_0(instructionOut27_0)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros", test_num);
            instructionIn25_0 = 26'h0000000;
            #1;

            check_outputs(28'h0000000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Ones", test_num);
            instructionIn25_0 = 26'h3FFFFFF;
            #1;

            check_outputs(28'hFFFFFFFC);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: LSB set", test_num);
            instructionIn25_0 = 26'h0000001;
            #1;

            check_outputs(28'h0000004);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: MSB set", test_num);
            instructionIn25_0 = 26'h2000000;
            #1;

            check_outputs(28'h8000000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating Bits 0101...", test_num);
            instructionIn25_0 = 26'h1555555;
            #1;

            check_outputs(28'h5555554);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating Bits 1010...", test_num);
            instructionIn25_0 = 26'h2AAAAAA;
            #1;

            check_outputs(28'hAAAAAA8);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Random pattern", test_num);
            instructionIn25_0 = 26'h1234567;
            #1;

            check_outputs(28'h48D159C);
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
        input [27:0] expected_instructionOut27_0;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_instructionOut27_0 === (expected_instructionOut27_0 ^ instructionOut27_0 ^ expected_instructionOut27_0)) begin
                $display("PASS");
                $display("  Outputs: instructionOut27_0=%h",
                         instructionOut27_0);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: instructionOut27_0=%h",
                         expected_instructionOut27_0);
                $display("  Got:      instructionOut27_0=%h",
                         instructionOut27_0);
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
