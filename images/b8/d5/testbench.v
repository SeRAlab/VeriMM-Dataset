`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [5:0] a_V;
    reg [6:0] w_V;
    wire ap_ready;
    wire [15:0] ap_return;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a_V(a_V),
        .w_V(w_V),
        .ap_ready(ap_ready),
        .ap_return(ap_return)
    );
    task testcase001;

        begin
            test_num = 1;
            a_V = 6'd0;
            w_V = 7'd0;
            $display("Test %0d: Zero Inputs (0 * 0 << 5)", test_num);
            #1;

            check_outputs(1'b1, 16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            a_V = 6'd5;
            w_V = 7'd10;

            $display("Test %0d: Positive * Positive (5 * 10 << 5)", test_num);
            #1;

            check_outputs(1'b1, 16'h0640);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            a_V = -6'sd5;
            w_V = 7'sd10;

            $display("Test %0d: Negative * Positive (-5 * 10 << 5)", test_num);
            #1;

            check_outputs(1'b1, 16'hF9C0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            a_V = 6'sd5;
            w_V = -7'sd10;

            $display("Test %0d: Positive * Negative (5 * -10 << 5)", test_num);
            #1;

            check_outputs(1'b1, 16'hF9C0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            a_V = -6'sd5;
            w_V = -7'sd10;

            $display("Test %0d: Negative * Negative (-5 * -10 << 5)", test_num);
            #1;

            check_outputs(1'b1, 16'h0640);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            a_V = 6'sd31;
            w_V = 7'sd63;

            $display("Test %0d: Max Positive (31 * 63 << 5)", test_num);
            #1;

            check_outputs(1'b1, 16'hF420);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            a_V = -6'sd32;
            w_V = 7'sd1;

            $display("Test %0d: Min Negative a_V (-32 * 1 << 5)", test_num);
            #1;

            check_outputs(1'b1, 16'hFC00);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            a_V = 6'sd1;
            w_V = -7'sd64;

            $display("Test %0d: Min Negative w_V (1 * -64 << 5)", test_num);
            #1;

            check_outputs(1'b1, 16'hF800);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            a_V = -6'sd32;
            w_V = 7'sd63;


            $display("Test %0d: Large Negative Product (-32 * 63 << 5)", test_num);
            #1;

            check_outputs(1'b1, 16'h0400);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            a_V = -6'sd32;
            w_V = -7'sd64;


            $display("Test %0d: Max Magnitude Product (-32 * -64 << 5)", test_num);
            #1;

            check_outputs(1'b1, 16'h0000);
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
        input expected_ap_ready;
        input [15:0] expected_ap_return;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ap_ready === (expected_ap_ready ^ ap_ready ^ expected_ap_ready) &&
                expected_ap_return === (expected_ap_return ^ ap_return ^ expected_ap_return)) begin
                $display("PASS");
                $display("  Outputs: ap_ready=%b, ap_return=%h",
                         ap_ready, ap_return);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ap_ready=%b, ap_return=%h",
                         expected_ap_ready, expected_ap_return);
                $display("  Got:      ap_ready=%b, ap_return=%h",
                         ap_ready, ap_return);
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
