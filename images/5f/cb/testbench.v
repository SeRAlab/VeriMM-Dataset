`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] a;
    reg ap_start;
    reg [15:0] b;
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

    // Clock generation (10ns period)
    initial begin
        ap_start = 0;
        forever #5 ap_start = ~ap_start;
    end

        task reset_dut;

        begin
            ap_rst = 1;
            ap_start = 0;
            a = 0;
            b = 0;
            repeat(2) @(posedge clk);
            ap_rst = 0;
            repeat(2) @(posedge clk);
        end
        endtask
    task run_multiplication;

        input [15:0] val_a;
        input [15:0] val_b;
        begin
            a = val_a;
            b = val_b;
            ap_start = 1;
            @(posedge clk);
            while (ap_ready == 0) @(posedge clk);
            ap_start = 0;
            while (ap_done == 0) @(posedge clk);
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            $display("Test %0d: 0 * 0", test_num);
            run_multiplication(16'd0, 16'd0);
            #1;

            check_outputs(1, 0, 1, 32'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            $display("Test %0d: 123 * 0", test_num);
            run_multiplication(16'd123, 16'd0);
            #1;

            check_outputs(1, 0, 1, 32'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            $display("Test %0d: 456 * 1", test_num);
            run_multiplication(16'd456, 16'd1);
            #1;

            check_outputs(1, 0, 1, 32'd456);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            $display("Test %0d: 10 * 5", test_num);
            run_multiplication(16'd10, 16'd5);
            #1;

            check_outputs(1, 0, 1, 32'd50);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            $display("Test %0d: 65535 * 1", test_num);
            run_multiplication(16'hFFFF, 16'd1);
            #1;

            check_outputs(1, 0, 1, 32'h0000FFFF);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            $display("Test %0d: 1 * 65535", test_num);
            run_multiplication(16'd1, 16'hFFFF);
            #1;

            check_outputs(1, 0, 1, 32'h0000FFFF);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            $display("Test %0d: 1234 * 5678", test_num);
            run_multiplication(16'd1234, 16'd5678);
            #1;

            check_outputs(1, 0, 1, 32'd7006652);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            reset_dut();
            $display("Test %0d: 65535 * 65535", test_num);
            run_multiplication(16'hFFFF, 16'hFFFF);
            #1;

            check_outputs(1, 0, 1, 32'hFFFE0001);
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
        input expected_ap_done;
        input expected_ap_idle;
        input expected_ap_ready;
        input [31:0] expected_ap_return;
        begin
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,a, ap_start, b, ap_done, ap_idle, ap_ready, ap_return);
    end

endmodule
