`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [9:0] y;
    wire [9:0] xor_result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .y(y),
        .xor_result(xor_result)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input all zeros", test_num);
            y = 10'h000;
            #1;

            check_outputs(10'h3F3);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input all ones", test_num);
            y = 10'h3FF;
            #1;

            check_outputs(10'h00C);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input matches mask 3F3", test_num);
            y = 10'h3F3;
            #1;

            check_outputs(10'h000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input matches bitwise inverse of mask", test_num);
            y = 10'h00C;
            #1;

            check_outputs(10'h3FF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Arbitrary pattern 123", test_num);
            y = 10'h123;



            #1;




            check_outputs(10'h2D0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Arbitrary pattern 2AA", test_num);
            y = 10'h2AA;



            #1;




            check_outputs(10'h159);
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
        input [9:0] expected_xor_result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_xor_result === (expected_xor_result ^ xor_result ^ expected_xor_result)) begin
                $display("PASS");
                $display("  Outputs: xor_result=%h",
                         xor_result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: xor_result=%h",
                         expected_xor_result);
                $display("  Got:      xor_result=%h",
                         xor_result);
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
