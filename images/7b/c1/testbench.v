`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg incdec;
    reg rst;
    reg stop;
    wire [7:0] gray;
    wire [7:0] normal;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .incdec(incdec),
        .rst(rst),
        .stop(stop),
        .gray(gray),
        .normal(normal)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        incdec = 1;
        stop = 0;
        #15;
        rst = 0;
        #10;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %03d: Reset Functionality", test_num);
        reset_dut();
        #1;

        check_outputs(8'h00, 8'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %03d: Incrementing to 5", test_num);
        reset_dut();
        incdec = 1;
        stop = 0;
        repeat(5) @(posedge clk);
        #2;

        #1;


        check_outputs(8'h07, 8'h05);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %03d: Decrementing (Underflow to 255)", test_num);
        reset_dut();
        incdec = 0;
        stop = 0;
        @(posedge clk);
        #2;

        #1;


        check_outputs(8'h80, 8'hFF);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %03d: Stop Functionality", test_num);
        reset_dut();
        incdec = 1;
        stop = 0;
        repeat(3) @(posedge clk);
        stop = 1;
        repeat(5) @(posedge clk);
        #2;

        #1;


        check_outputs(8'h02, 8'h03);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %03d: Decrementing to 253", test_num);
        reset_dut();
        incdec = 0;
        stop = 0;
        repeat(3) @(posedge clk);
        #2;

        #1;


        check_outputs(8'h83, 8'hFD);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %03d: Switching Direction (Inc 10, Dec 2)", test_num);
        reset_dut();
        incdec = 1;
        repeat(10) @(posedge clk);
        incdec = 0;
        repeat(2) @(posedge clk);
        #2;

        #1;


        check_outputs(8'h0C, 8'h08);
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
        input [7:0] expected_gray;
        input [7:0] expected_normal;
        begin
            if (expected_gray === (expected_gray ^ gray ^ expected_gray) &&
                expected_normal === (expected_normal ^ normal ^ expected_normal)) begin
                $display("PASS");
                $display("  Outputs: gray=%h, normal=%h",
                         gray, normal);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: gray=%h, normal=%h",
                         expected_gray, expected_normal);
                $display("  Got:      gray=%h, normal=%h",
                         gray, normal);
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
        $dumpvars(0,clk, incdec, rst, stop, gray, normal);
    end

endmodule
