`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg reset_n;
    reg test_expr;
    reg xzcheck_enable;
    reg xzdetect_bit;
    wire [1:0] fail_reason;
    wire pass;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .reset_n(reset_n),
        .test_expr(test_expr),
        .xzcheck_enable(xzcheck_enable),
        .xzdetect_bit(xzdetect_bit),
        .fail_reason(fail_reason),
        .pass(pass)
    );

    // Clock generation (10ns period)
    initial begin
        reset_n = 0;
        forever #5 reset_n = ~reset_n;
    end

        task reset_dut;

        begin
            @(negedge reset_n);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Reset Period Initialization", test_num);
            reset_dut();

            test_expr = 1'b1;
            xzdetect_bit = 1'b1;
            xzcheck_enable = 1'b1;
            #2;

            #1;


            check_outputs(2'b00, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Valid Expression (Pass)", test_num);
            reset_dut();
            test_expr = 1'b1;
            xzdetect_bit = 1'b0;
            xzcheck_enable = 1'b1;
            @(posedge reset_n);
            #2;
            #1;

            check_outputs(2'b00, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Logical False Expression (Fail 10)", test_num);
            reset_dut();
            test_expr = 1'b0;
            xzdetect_bit = 1'b0;
            xzcheck_enable = 1'b1;
            @(posedge reset_n);
            #2;
            #1;

            check_outputs(2'b10, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Unknown State X (Fail 01)", test_num);
            reset_dut();
            test_expr = 1'bx;
            xzdetect_bit = 1'b1;
            xzcheck_enable = 1'b1;
            @(posedge reset_n);
            #2;
            #1;

            check_outputs(2'b01, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Unknown State Z (Fail 01)", test_num);
            reset_dut();
            test_expr = 1'bz;
            xzdetect_bit = 1'b1;
            xzcheck_enable = 1'b1;
            @(posedge reset_n);
            #2;
            #1;

            check_outputs(2'b01, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Priority Check (XZ over Logic)", test_num);
            reset_dut();

            test_expr = 1'bx;
            xzdetect_bit = 1'b1;
            xzcheck_enable = 1'b1;
            @(posedge reset_n);
            #2;

            #1;


            check_outputs(2'b01, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Unknown State X with xzdetect disabled", test_num);
            reset_dut();
            test_expr = 1'bx;
            xzdetect_bit = 1'b0;
            xzcheck_enable = 1'b1;
            @(posedge reset_n);
            #2;


            #1;



            check_outputs(2'b00, 1'b1);
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
        input [1:0] expected_fail_reason;
        input expected_pass;
        begin
            if (expected_fail_reason === (expected_fail_reason ^ fail_reason ^ expected_fail_reason) &&
                expected_pass === (expected_pass ^ pass ^ expected_pass)) begin
                $display("PASS");
                $display("  Outputs: fail_reason=%h, pass=%b",
                         fail_reason, pass);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: fail_reason=%h, pass=%b",
                         expected_fail_reason, expected_pass);
                $display("  Got:      fail_reason=%h, pass=%b",
                         fail_reason, pass);
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,reset_n, test_expr, xzcheck_enable, xzdetect_bit, fail_reason, pass);
    end

endmodule
