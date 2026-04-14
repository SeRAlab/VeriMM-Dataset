`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [29:0] a1;
    reg [29:0] b1;
    wire c_out;
    wire [29:0] sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a1(a1),
        .b1(b1),
        .c_out(c_out),
        .sum(sum)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Zero addition", test_num);
            a1 = 30'h0;
            b1 = 30'h0;
            #1;

            check_outputs(1'b0, 30'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Simple addition (1+1)", test_num);
            a1 = 30'h1;
            b1 = 30'h1;
            #1;

            check_outputs(1'b0, 30'h2);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Max input value with zero", test_num);
            a1 = 30'h3FFFFFFF;
            b1 = 30'h0;
            #1;

            check_outputs(1'b0, 30'h3FFFFFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Carry out generation (Overflow)", test_num);
            a1 = 30'h3FFFFFFF;
            b1 = 30'h1;
            #1;

            check_outputs(1'b1, 30'h0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Maximum possible addition", test_num);
            a1 = 30'h3FFFFFFF;
            b1 = 30'h3FFFFFFF;
            #1;

            check_outputs(1'b1, 30'h3FFFFFFE);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Checkerboard bit pattern", test_num);
            a1 = 30'h15555555;
            b1 = 30'h2AAAAAAA;
            #1;

            check_outputs(1'b0, 30'h3FFFFFFF);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Carry propagation from mid-bits", test_num);
            a1 = 30'h00007FFF;
            b1 = 30'h00000001;
            #1;

            check_outputs(1'b0, 30'h00008000);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Overflow from MSB bit", test_num);
            a1 = 30'h20000000;
            b1 = 30'h20000000;
            #1;

            check_outputs(1'b1, 30'h00000000);
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
        input expected_c_out;
        input [29:0] expected_sum;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_c_out === (expected_c_out ^ c_out ^ expected_c_out) &&
                expected_sum === (expected_sum ^ sum ^ expected_sum)) begin
                $display("PASS");
                $display("  Outputs: c_out=%b, sum=%h",
                         c_out, sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: c_out=%b, sum=%h",
                         expected_c_out, expected_sum);
                $display("  Got:      c_out=%b, sum=%h",
                         c_out, sum);
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
