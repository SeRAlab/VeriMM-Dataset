`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg in;
    reg rst;
    wire [31:0] count_h;
    wire [31:0] count_l;
    wire detected;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in(in),
        .rst(rst),
        .count_h(count_h),
        .count_l(count_l),
        .detected(detected)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            in = 0;

            repeat(2) @(posedge clk);
            #1 rst = 0;

            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: H=10, L=20");
            reset_dut();
            test_num = 1;

            @(negedge clk) in = 1;
            repeat(10) @(negedge clk);
            in = 0;
            repeat(20) @(negedge clk);


            in = 1;
            @(negedge clk);


            #1;



            check_outputs(32'd10, 32'd20, 1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: H=5, L=5");
            reset_dut();
            test_num = 2;

            @(negedge clk) in = 1;
            repeat(5) @(negedge clk);
            in = 0;
            repeat(5) @(negedge clk);

            in = 1;
            @(negedge clk);

            #1;


            check_outputs(32'd5, 32'd5, 1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: H=1, L=1");
            reset_dut();
            test_num = 3;

            @(negedge clk) in = 1;
            repeat(1) @(negedge clk);
            in = 0;
            repeat(1) @(negedge clk);

            in = 1;
            @(negedge clk);

            #1;


            check_outputs(32'd1, 32'd1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: H=100, L=50");
            reset_dut();
            test_num = 4;

            @(negedge clk) in = 1;
            repeat(100) @(negedge clk);
            in = 0;
            repeat(50) @(negedge clk);

            in = 1;
            @(negedge clk);

            #1;


            check_outputs(32'd100, 32'd50, 1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Reset Verification");
            reset_dut();
            test_num = 5;


            #1;
            #1;

            check_outputs(32'd0, 32'd0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: Initial Low period (H=0, L=15)");
            reset_dut();
            test_num = 6;


            repeat(15) @(negedge clk);


            in = 1;
            @(negedge clk);

            #1;


            check_outputs(32'd0, 32'd15, 1'b1);
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
        input [31:0] expected_count_h;
        input [31:0] expected_count_l;
        input expected_detected;
        begin
            if (expected_count_h === (expected_count_h ^ count_h ^ expected_count_h) &&
                expected_count_l === (expected_count_l ^ count_l ^ expected_count_l) &&
                expected_detected === (expected_detected ^ detected ^ expected_detected)) begin
                $display("PASS");
                $display("  Outputs: count_h=%h, count_l=%h, detected=%b",
                         count_h, count_l, detected);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count_h=%h, count_l=%h, detected=%b",
                         expected_count_h, expected_count_l, expected_detected);
                $display("  Got:      count_h=%h, count_l=%h, detected=%b",
                         count_h, count_l, detected);
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
        $dumpvars(0,clk, in, rst, count_h, count_l, detected);
    end

endmodule
