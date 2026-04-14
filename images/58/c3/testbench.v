`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] x;
    reg [15:0] y;
    wire out_equal;
    wire out_greater;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .x(x),
        .y(y),
        .out_equal(out_equal),
        .out_greater(out_greater)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Equal zeros", test_num);
            x = 16'h0000;
            y = 16'h0000;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: x greater than y (small values)", test_num);
            x = 16'h0005;
            y = 16'h0002;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: x less than y (small values)", test_num);
            x = 16'h000A;
            y = 16'h0014;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Equal maximum values", test_num);
            x = 16'hFFFF;
            y = 16'hFFFF;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: x is max, y is zero", test_num);
            x = 16'hFFFF;
            y = 16'h0000;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: x is zero, y is max", test_num);
            x = 16'h0000;
            y = 16'hFFFF;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: x greater than y (MSB difference)", test_num);
            x = 16'h8000;
            y = 16'h7FFF;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: x less than y (MSB difference)", test_num);
            x = 16'h7FFF;
            y = 16'h8000;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: x greater than y (LSB difference)", test_num);
            x = 16'h0001;
            y = 16'h0000;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: x less than y (LSB difference)", test_num);
            x = 16'hFFFE;
            y = 16'hFFFF;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase011;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Random pattern match", test_num);
            x = 16'hA5A5;
            y = 16'hA5A5;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase012;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Random pattern comparison", test_num);
            x = 16'h1234;
            y = 16'h4321;
            #1;

            check_outputs(1'b0, 1'b0);
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
        input expected_out_equal;
        input expected_out_greater;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out_equal === (expected_out_equal ^ out_equal ^ expected_out_equal) &&
                expected_out_greater === (expected_out_greater ^ out_greater ^ expected_out_greater)) begin
                $display("PASS");
                $display("  Outputs: out_equal=%b, out_greater=%b",
                         out_equal, out_greater);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_equal=%b, out_greater=%b",
                         expected_out_equal, expected_out_greater);
                $display("  Got:      out_equal=%b, out_greater=%b",
                         out_equal, out_greater);
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
