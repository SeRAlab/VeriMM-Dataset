`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg C;
    wire [4:0] diff;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .C(C),
        .diff(diff)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            A = 4'sd5; B = 4'sd2; C = 1'b0;
            #1;

            check_outputs(5'sd3);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            A = 4'sd2; B = 4'sd5; C = 1'b0;
            #1;

            check_outputs(5'sh1D);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            A = 4'sd7; B = 4'sb1000; C = 1'b0;
            #1;

            check_outputs(5'sd15);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            A = 4'sb1000; B = 4'sd7; C = 1'b0;
            #1;

            check_outputs(5'sh11);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            A = 4'sd5; B = 4'sd2; C = 1'b1;
            #1;

            check_outputs(5'sd7);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            A = 4'sb1011; B = 4'sd3; C = 1'b1;
            #1;

            check_outputs(5'sh1E);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            A = 4'sd7; B = 4'sd7; C = 1'b1;
            #1;

            check_outputs(5'sd14);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            A = 4'sb1000; B = 4'sb1000; C = 1'b1;
            #1;

            check_outputs(5'sh10);
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
        input [4:0] expected_diff;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_diff === (expected_diff ^ diff ^ expected_diff)) begin
                $display("PASS");
                $display("  Outputs: diff=%h",
                         diff);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: diff=%h",
                         expected_diff);
                $display("  Got:      diff=%h",
                         diff);
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
