`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg ctl_pad_clk_se;
    reg ctl_pad_clk_si;
    reg data;
    reg rst_l;
    reg testmode_l;
    wire to_pad;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .ctl_pad_clk_se(ctl_pad_clk_se),
        .ctl_pad_clk_si(ctl_pad_clk_si),
        .data(data),
        .rst_l(rst_l),
        .testmode_l(testmode_l),
        .to_pad(to_pad)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_l = 0;
            testmode_l = 1;
            ctl_pad_clk_se = 0;
            ctl_pad_clk_si = 1;
            data = 0;
            @(posedge clk);
            #2 rst_l = 1;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Testing Reset state", test_num);
            reset_dut();
            rst_l = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(1'bz);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Testing Testmode active", test_num);
            reset_dut();
            testmode_l = 0;
            data = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(1'bz);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Positive edge on ctl_pad_clk_se", test_num);
            reset_dut();

            data = 1;
            ctl_pad_clk_se = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Negative edge on ctl_pad_clk_si", test_num);
            reset_dut();

            data = 0;
            ctl_pad_clk_si = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: No control edge transition", test_num);
            reset_dut();

            data = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(1'bz);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Invalid edge types (SE falling, SI rising)", test_num);
            reset_dut();

            ctl_pad_clk_se = 1;
            ctl_pad_clk_si = 0;
            @(posedge clk);
            #1;
            data = 1;
            ctl_pad_clk_se = 0;
            ctl_pad_clk_si = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(1'bz);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Data change without control edge", test_num);
            reset_dut();

            ctl_pad_clk_se = 1;
            data = 1;
            @(posedge clk);
            #1;

            data = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b1);
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
        input expected_to_pad;
        begin
            if (expected_to_pad === (expected_to_pad ^ to_pad ^ expected_to_pad)) begin
                $display("PASS");
                $display("  Outputs: to_pad=%b",
                         to_pad);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: to_pad=%b",
                         expected_to_pad);
                $display("  Got:      to_pad=%b",
                         to_pad);
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
        $dumpvars(0,clk, ctl_pad_clk_se, ctl_pad_clk_si, data, rst_l, testmode_l, to_pad);
    end

endmodule
