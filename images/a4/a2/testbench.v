`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] X;
    reg [15:0] Y;
    wire C;
    wire [15:0] sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .X(X),
        .Y(Y),
        .C(C),
        .sum(sum)
    );
    task testcase001;

        begin
            test_num = 1;
            X = 16'h0000;
            Y = 16'h0000;
            #1;

            check_outputs(1'b0, 16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            X = 16'hFFFF;
            Y = 16'h0001;
            #1;

            check_outputs(1'b1, 16'h0000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            X = 16'hAAAA;
            Y = 16'h5555;
            #1;

            check_outputs(1'b0, 16'hFFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            X = 16'h1234;
            Y = 16'h4321;
            #1;

            check_outputs(1'b0, 16'h5555);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            X = 16'hFFFF;
            Y = 16'hFFFF;
            #1;

            check_outputs(1'b1, 16'hFFFE);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            X = 16'h8000;
            Y = 16'h8000;
            #1;

            check_outputs(1'b1, 16'h0000);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            X = 16'h7FFF;
            Y = 16'h0001;
            #1;

            check_outputs(1'b0, 16'h8000);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            X = 16'h1234;
            Y = 16'hABCD;
            #1;

            check_outputs(1'b0, 16'hBE01);
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
        input expected_C;
        input [15:0] expected_sum;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_C === (expected_C ^ C ^ expected_C) &&
                expected_sum === (expected_sum ^ sum ^ expected_sum)) begin
                $display("PASS");
                $display("  Outputs: C=%b, sum=%h",
                         C, sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: C=%b, sum=%h",
                         expected_C, expected_sum);
                $display("  Got:      C=%b, sum=%h",
                         C, sum);
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
