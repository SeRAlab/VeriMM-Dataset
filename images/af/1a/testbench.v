`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk_d;
    reg one_pulse_min;
    reg rst;
    reg set_en;
    wire co_m1;
    wire [3:0] set_m0;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk_d(clk_d),
        .one_pulse_min(one_pulse_min),
        .rst(rst),
        .set_en(set_en),
        .co_m1(co_m1),
        .set_m0(set_m0)
    );

    // Clock generation (10ns period)
    initial begin
        clk_d = 0;
        forever #5 clk_d = ~clk_d;
    end

        task reset_dut;

        begin
            rst = 1;
            set_en = 0;
            one_pulse_min = 0;
            @(posedge clk_d);
            #2 rst = 0;
            @(posedge clk_d);
        end
        endtask
    task testcase001;

        begin
            reset_dut();

            #1;


            check_outputs(1'b0, 4'd0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            set_en = 1;
            one_pulse_min = 1;
            @(posedge clk_d);
            #2;
            #1;

            check_outputs(1'b0, 4'd1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            set_en = 0;
            one_pulse_min = 1;
            repeat(5) @(posedge clk_d);
            #2;
            #1;

            check_outputs(1'b0, 4'd0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            set_en = 1;
            one_pulse_min = 0;
            repeat(5) @(posedge clk_d);
            #2;
            #1;

            check_outputs(1'b0, 4'd0);
        end
        endtask

    task testcase005;

        integer i;
        begin
            reset_dut();
            set_en = 1;
            one_pulse_min = 1;
            repeat(9) @(posedge clk_d);
            #2;
            #1;

            check_outputs(1'b0, 4'd9);
        end
        endtask

    task testcase006;

        integer i;
        begin
            reset_dut();
            set_en = 1;
            one_pulse_min = 1;
            repeat(10) @(posedge clk_d);
            #2;

            #1;


            check_outputs(1'b1, 4'd0);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            set_en = 1;
            one_pulse_min = 1;
            repeat(20) @(posedge clk_d);
            #2;

            #1;


            check_outputs(1'b1, 4'd0);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            set_en = 1;
            one_pulse_min = 1;
            repeat(5) @(posedge clk_d);
            rst = 1;
            @(posedge clk_d);
            #2 rst = 0;
            #1;

            check_outputs(1'b0, 4'd0);
        end
        endtask

    task testcase009;

        begin
            reset_dut();
            set_en = 1;
            one_pulse_min = 1;
            @(posedge clk_d);
            one_pulse_min = 0;
            repeat(2) @(posedge clk_d);
            one_pulse_min = 1;
            @(posedge clk_d);
            #2;
            #1;

            check_outputs(1'b0, 4'd2);
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
        input expected_co_m1;
        input [3:0] expected_set_m0;
        begin
            if (expected_co_m1 === (expected_co_m1 ^ co_m1 ^ expected_co_m1) &&
                expected_set_m0 === (expected_set_m0 ^ set_m0 ^ expected_set_m0)) begin
                $display("PASS");
                $display("  Outputs: co_m1=%b, set_m0=%h",
                         co_m1, set_m0);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: co_m1=%b, set_m0=%h",
                         expected_co_m1, expected_set_m0);
                $display("  Got:      co_m1=%b, set_m0=%h",
                         co_m1, set_m0);
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
        $dumpvars(0,clk_d, one_pulse_min, rst, set_en, co_m1, set_m0);
    end

endmodule
