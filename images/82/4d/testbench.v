`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] float_a;
    reg [15:0] float_b;
    wire [15:0] float_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .float_a(float_a),
        .float_b(float_b),
        .float_out(float_out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: 1.0 * 1.0", test_num);
            float_a = 16'h3C00;
            float_b = 16'h3C00;
            #1;

            check_outputs(16'h3C00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: 2.0 * 3.0", test_num);
            float_a = 16'h4000;
            float_b = 16'h4200;
            #1;

            check_outputs(16'h4600);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: -2.0 * 2.5", test_num);
            float_a = 16'hC000;
            float_b = 16'h4100;
            #1;

            check_outputs(16'hC900);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: 0.5 * 0.5", test_num);
            float_a = 16'h3800;
            float_b = 16'h3800;
            #1;

            check_outputs(16'h3400);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: 0.0 * 5.0", test_num);
            float_a = 16'h0000;
            float_b = 16'h4500;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: -1.0 * -1.0", test_num);
            float_a = 16'hBC00;
            float_b = 16'hBC00;
            #1;

            check_outputs(16'h3C00);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: 1.25 * 1.25", test_num);
            float_a = 16'h3D00;
            float_b = 16'h3D00;
            #1;

            check_outputs(16'h3E40);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Exponent Overflow (Max * Max)", test_num);
            float_a = 16'h7BFF;
            float_b = 16'h7BFF;
            #1;

            check_outputs(16'h7C00);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Multiplication by Infinity", test_num);
            float_a = 16'h7C00;
            float_b = 16'h3C00;
            #1;

            check_outputs(16'h7C00);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Small fractional multiplication (Underflow)", test_num);
            float_a = 16'h0400;
            float_b = 16'h0400;
            #1;

            check_outputs(16'h0000);
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
        input [15:0] expected_float_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_float_out === (expected_float_out ^ float_out ^ expected_float_out)) begin
                $display("PASS");
                $display("  Outputs: float_out=%h",
                         float_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: float_out=%h",
                         expected_float_out);
                $display("  Got:      float_out=%h",
                         float_out);
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
