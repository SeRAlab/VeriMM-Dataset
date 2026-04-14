`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg pause;
    reg quick;
    reg rst;
    wire [1:0] sel;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .pause(pause),
        .quick(quick),
        .rst(rst),
        .sel(sel)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            pause = 0;
            quick = 0;
            repeat(2) @(posedge clk);
            #1 rst = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Standard Mode - First Transition", test_num);
            reset_dut();
            quick = 0;
            pause = 0;
            repeat(300) @(posedge clk);
            #1 #1;
 check_outputs(2'b01);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Standard Mode - High Range", test_num);
            reset_dut();
            quick = 0;
            pause = 0;
            repeat(800) @(posedge clk);
            #1 #1;
 check_outputs(2'b11);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Quick Mode - First Transition", test_num);
            reset_dut();
            quick = 1;
            pause = 0;
            repeat(150) @(posedge clk);
            #1 #1;
 check_outputs(2'b01);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Quick Mode - High Range", test_num);
            reset_dut();
            quick = 1;
            pause = 0;
            repeat(400) @(posedge clk);
            #1 #1;
 check_outputs(2'b11);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Pause Functionality", test_num);
            reset_dut();
            quick = 0;
            repeat(100) @(posedge clk);
            pause = 1;
            repeat(50) @(posedge clk);
            pause = 0;
            repeat(200) @(posedge clk);

            #1 #1;
 check_outputs(2'b01);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Counter Rollover (1024 cycles)", test_num);
            reset_dut();
            quick = 0;
            pause = 0;
            repeat(1024) @(posedge clk);
            #1 #1;
 check_outputs(2'b00);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %03d: Quick Mode with High Count", test_num);
            reset_dut();
            quick = 1;
            pause = 0;
            repeat(640) @(posedge clk);

            #1 #1;
 check_outputs(2'b01);
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
        input [1:0] expected_sel;
        begin
            if (expected_sel === (expected_sel ^ sel ^ expected_sel)) begin
                $display("PASS");
                $display("  Outputs: sel=%h",
                         sel);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: sel=%h",
                         expected_sel);
                $display("  Got:      sel=%h",
                         sel);
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
        $dumpvars(0,clk, pause, quick, rst, sel);
    end

endmodule
