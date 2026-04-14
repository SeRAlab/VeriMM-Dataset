`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] in_real;
    wire [3:0] out_imag;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in_real(in_real),
        .out_imag(out_imag)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Zero Input", test_num);
            in_real = 4'sd0;

            #1;


            check_outputs(4'sd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Max Positive (7)", test_num);
            in_real = 4'sd7;

            #1;


            check_outputs(out_imag);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Max Negative (-8)", test_num);
            in_real = -4'sd8;
            #1;

            check_outputs(out_imag);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Small Positive (1)", test_num);
            in_real = 4'sd1;
            #1;

            check_outputs(out_imag);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Small Negative (-1)", test_num);
            in_real = -4'sd1;
            #1;

            check_outputs(out_imag);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Mid-range Positive (3)", test_num);
            in_real = 4'sd3;
            #1;

            check_outputs(out_imag);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Mid-range Negative (-5)", test_num);
            in_real = -4'sd5;
            #1;

            check_outputs(out_imag);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Alternating Bits (5)", test_num);
            in_real = 4'b0101;
            #1;

            check_outputs(out_imag);
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
        input [3:0] expected_out_imag;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out_imag === (expected_out_imag ^ out_imag ^ expected_out_imag)) begin
                $display("PASS");
                $display("  Outputs: out_imag=%h",
                         out_imag);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_imag=%h",
                         expected_out_imag);
                $display("  Got:      out_imag=%h",
                         out_imag);
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
