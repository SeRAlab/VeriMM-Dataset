`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg value;
    wire [3:0] an;
    wire [6:0] segments;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .value(value),
        .an(an),
        .segments(segments)
    );
    task testcase001;

        begin
            test_num = 1;
            value = 1'b1;
            #10;




            #1;





            check_outputs(4'b0111, 7'b0000001);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            value = 1'b0;
            #10;




            #1;





            check_outputs(4'b1011, 7'b1001111);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            value = 1'b1;
            #5;
            value = 1'b0;
            #10;
            #1;

            check_outputs(4'b1011, 7'b1001111);
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
        input [3:0] expected_an;
        input [6:0] expected_segments;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_an === (expected_an ^ an ^ expected_an) &&
                expected_segments === (expected_segments ^ segments ^ expected_segments)) begin
                $display("PASS");
                $display("  Outputs: an=%h, segments=%h",
                         an, segments);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: an=%h, segments=%h",
                         expected_an, expected_segments);
                $display("  Got:      an=%h, segments=%h",
                         an, segments);
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
