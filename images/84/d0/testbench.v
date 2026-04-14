`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] a;
    reg ap_start;
    reg [31:0] b;
    wire ap_done;
    wire ap_idle;
    wire ap_ready;
    wire [31:0] ap_return;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .ap_start(ap_start),
        .b(b),
        .ap_done(ap_done),
        .ap_idle(ap_idle),
        .ap_ready(ap_ready),
        .ap_return(ap_return)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Zero Multiplication (0 * 0)", test_num);
            ap_start = 1'b1;
            a = 32'd0;
            b = 32'd0;
            #10;

            #1;


            check_outputs(1'b1, 1'b0, 1'b1, 32'd0);
            ap_start = 1'b0;
            #10;
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Simple Multiplication (12 * 11)", test_num);
            ap_start = 1'b1;
            a = 32'd12;
            b = 32'd11;
            #10;

            #1;


            check_outputs(1'b1, 1'b0, 1'b1, 32'd132);
            ap_start = 1'b0;
            #10;
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Multiplication by One", test_num);
            ap_start = 1'b1;
            a = 32'hABCDE;
            b = 32'd1;
            #10;
            #1;

            check_outputs(1'b1, 1'b0, 1'b1, 32'hABCDE);
            ap_start = 1'b0;
            #10;
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Multiply by Max Value (32-bit)", test_num);
            ap_start = 1'b1;
            a = 32'hFFFFFFFF;
            b = 32'd1;
            #10;
            #1;

            check_outputs(1'b1, 1'b0, 1'b1, 32'hFFFFFFFF);
            ap_start = 1'b0;
            #10;
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Overflow Truncation (2^16 * 2^16)", test_num);
            ap_start = 1'b1;
            a = 32'd65536;
            b = 32'd65536;
            #10;

            #1;


            check_outputs(1'b1, 1'b0, 1'b1, 32'd0);
            ap_start = 1'b0;
            #10;
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Large Value Multiplication", test_num);
            ap_start = 1'b1;
            a = 32'h12345678;
            b = 32'd2;
            #10;

            #1;


            check_outputs(1'b1, 1'b0, 1'b1, 32'h2468ACF0);
            ap_start = 1'b0;
            #10;
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Idle State Check", test_num);
            ap_start = 1'b0;
            a = 32'd50;
            b = 32'd2;
            #10;

            #1;


            check_outputs(1'b0, 1'b1, 1'b0, 32'd100);
            #10;
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
        input expected_ap_done;
        input expected_ap_idle;
        input expected_ap_ready;
        input [31:0] expected_ap_return;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ap_done === (expected_ap_done ^ ap_done ^ expected_ap_done) &&
                expected_ap_idle === (expected_ap_idle ^ ap_idle ^ expected_ap_idle) &&
                expected_ap_ready === (expected_ap_ready ^ ap_ready ^ expected_ap_ready) &&
                expected_ap_return === (expected_ap_return ^ ap_return ^ expected_ap_return)) begin
                $display("PASS");
                $display("  Outputs: ap_done=%b, ap_idle=%b, ap_ready=%b, ap_return=%h",
                         ap_done, ap_idle, ap_ready, ap_return);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ap_done=%b, ap_idle=%b, ap_ready=%b, ap_return=%h",
                         expected_ap_done, expected_ap_idle, expected_ap_ready, expected_ap_return);
                $display("  Got:      ap_done=%b, ap_idle=%b, ap_ready=%b, ap_return=%h",
                         ap_done, ap_idle, ap_ready, ap_return);
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
