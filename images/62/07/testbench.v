`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg bit_a;
    reg bit_b;
    reg bit_carry_in;
    reg start;
    wire bit_carry_out;
    wire bit_sum;
    wire done;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .bit_a(bit_a),
        .bit_b(bit_b),
        .bit_carry_in(bit_carry_in),
        .start(start),
        .bit_carry_out(bit_carry_out),
        .bit_sum(bit_sum),
        .done(done)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: bit_a=0, bit_b=0, bit_carry_in=0, start=1", test_num);
            bit_a = 1'b0;
            bit_b = 1'b0;
            bit_carry_in = 1'b0;
            start = 1'b1;
            #1;

            check_outputs(1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: bit_a=0, bit_b=0, bit_carry_in=1, start=1", test_num);
            bit_a = 1'b0;
            bit_b = 1'b0;
            bit_carry_in = 1'b1;
            start = 1'b1;
            #1;

            check_outputs(1'b0, 1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: bit_a=0, bit_b=1, bit_carry_in=0, start=1", test_num);
            bit_a = 1'b0;
            bit_b = 1'b1;
            bit_carry_in = 1'b0;
            start = 1'b1;
            #1;

            check_outputs(1'b0, 1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: bit_a=0, bit_b=1, bit_carry_in=1, start=1", test_num);
            bit_a = 1'b0;
            bit_b = 1'b1;
            bit_carry_in = 1'b1;
            start = 1'b1;
            #1;

            check_outputs(1'b1, 1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: bit_a=1, bit_b=0, bit_carry_in=0, start=1", test_num);
            bit_a = 1'b1;
            bit_b = 1'b0;
            bit_carry_in = 1'b0;
            start = 1'b1;
            #1;

            check_outputs(1'b0, 1'b1, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: bit_a=1, bit_b=0, bit_carry_in=1, start=1", test_num);
            bit_a = 1'b1;
            bit_b = 1'b0;
            bit_carry_in = 1'b1;
            start = 1'b1;
            #1;

            check_outputs(1'b1, 1'b0, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: bit_a=1, bit_b=1, bit_carry_in=0, start=1", test_num);
            bit_a = 1'b1;
            bit_b = 1'b1;
            bit_carry_in = 1'b0;
            start = 1'b1;
            #1;

            check_outputs(1'b1, 1'b0, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: bit_a=1, bit_b=1, bit_carry_in=1, start=1", test_num);
            bit_a = 1'b1;
            bit_b = 1'b1;
            bit_carry_in = 1'b1;
            start = 1'b1;
            #1;

            check_outputs(1'b1, 1'b1, 1'b1);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: bit_a=1, bit_b=1, bit_carry_in=1, start=0 (Testing start/done logic)", test_num);
            bit_a = 1'b1;
            bit_b = 1'b1;
            bit_carry_in = 1'b1;
            start = 1'b0;
            #1;

            check_outputs(1'b1, 1'b1, 1'b0);
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
        input expected_bit_carry_out;
        input expected_bit_sum;
        input expected_done;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_bit_carry_out === (expected_bit_carry_out ^ bit_carry_out ^ expected_bit_carry_out) &&
                expected_bit_sum === (expected_bit_sum ^ bit_sum ^ expected_bit_sum) &&
                expected_done === (expected_done ^ done ^ expected_done)) begin
                $display("PASS");
                $display("  Outputs: bit_carry_out=%b, bit_sum=%b, done=%b",
                         bit_carry_out, bit_sum, done);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: bit_carry_out=%b, bit_sum=%b, done=%b",
                         expected_bit_carry_out, expected_bit_sum, expected_done);
                $display("  Got:      bit_carry_out=%b, bit_sum=%b, done=%b",
                         bit_carry_out, bit_sum, done);
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
