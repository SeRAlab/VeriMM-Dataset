`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg miniscope_sync;
    reg reset;
    reg start;
    reg stop;
    wire [31:0] frame_count;
    wire miniscope_trig;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .miniscope_sync(miniscope_sync),
        .reset(reset),
        .start(start),
        .stop(stop),
        .frame_count(frame_count),
        .miniscope_trig(miniscope_trig)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        start = 0;
        stop = 0;
        miniscope_sync = 0;
        @(posedge clk);
        #1;
        reset = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Post-reset state check", test_num);
        reset_dut();

        #1;


        check_outputs(32'd0, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Triggering start", test_num);
        reset_dut();
        @(posedge clk);
        start = 1;
        @(posedge clk);
        start = 0;
        repeat(2) @(posedge clk);

        #1;


        check_outputs(32'd0, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Start then stop", test_num);
        reset_dut();
        @(posedge clk);
        start = 1;
        @(posedge clk);
        start = 0;
        repeat(5) @(posedge clk);
        stop = 1;
        @(posedge clk);
        stop = 0;
        @(posedge clk);

        #1;


        check_outputs(32'd0, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Frame counting (3 sync pulses)", test_num);
        reset_dut();



        repeat(3) begin
            @(posedge clk);
            miniscope_sync = 1;
            repeat(2) @(posedge clk);
            miniscope_sync = 0;
            repeat(2) @(posedge clk);
        end

        #1;


        check_outputs(32'd3, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Reset during recording and counting", test_num);
        reset_dut();

        @(posedge clk);
        start = 1;
        @(posedge clk);
        start = 0;

        @(posedge clk);
        miniscope_sync = 1;
        @(posedge clk);
        miniscope_sync = 0;
        @(posedge clk);

        reset = 1;
        @(posedge clk);
        reset = 0;
        @(posedge clk);

        #1;


        check_outputs(32'd0, 1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Multiple start/stop with cumulative counting", test_num);
        reset_dut();


        start = 1; @(posedge clk); start = 0;
        repeat(2) begin
            miniscope_sync = 1; @(posedge clk); miniscope_sync = 0; @(posedge clk);
        end
        stop = 1; @(posedge clk); stop = 0; @(posedge clk);


        start = 1; @(posedge clk); start = 0;
        repeat(3) begin
            miniscope_sync = 1; @(posedge clk); miniscope_sync = 0; @(posedge clk);
        end
        stop = 1; @(posedge clk); stop = 0; @(posedge clk);


        #1;



        check_outputs(32'd5, 1'b0);
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
        input [31:0] expected_frame_count;
        input expected_miniscope_trig;
        begin
            if (expected_frame_count === (expected_frame_count ^ frame_count ^ expected_frame_count) &&
                expected_miniscope_trig === (expected_miniscope_trig ^ miniscope_trig ^ expected_miniscope_trig)) begin
                $display("PASS");
                $display("  Outputs: frame_count=%h, miniscope_trig=%b",
                         frame_count, miniscope_trig);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: frame_count=%h, miniscope_trig=%b",
                         expected_frame_count, expected_miniscope_trig);
                $display("  Got:      frame_count=%h, miniscope_trig=%b",
                         frame_count, miniscope_trig);
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
        $dumpvars(0,clk, miniscope_sync, reset, start, stop, frame_count, miniscope_trig);
    end

endmodule
