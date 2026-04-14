`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg io_enable;
    reg [31:0] io_max;
    reg reset;
    wire io_done;
    wire [31:0] io_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .io_enable(io_enable),
        .io_max(io_max),
        .reset(reset),
        .io_done(io_done),
        .io_out(io_out)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

    begin
        reset = 1;
        io_enable = 0;
        io_max = 5;
        @(posedge clock);
        #2;
        reset = 0;
        @(posedge clock);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Checking Reset State", test_num);
        reset_dut();
        #1;

        check_outputs(1'b0, 32'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Checking partial increment (count to 3)", test_num);
        reset_dut();
        io_enable = 1;
        io_max = 5;
        repeat(3) @(posedge clock);
        #1;
        #1;

        check_outputs(1'b0, 32'd3);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Reaching max value (5) and io_done", test_num);
        reset_dut();
        io_enable = 1;
        io_max = 5;
        repeat(5) @(posedge clock);
        #1;
        #1;

        check_outputs(1'b1, 32'd5);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Wrap-around logic (6 cycles)", test_num);
        reset_dut();
        io_enable = 1;
        io_max = 5;
        repeat(6) @(posedge clock);
        #1;
        #1;

        check_outputs(1'b0, 32'd0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Enable signal check (pause at 2)", test_num);
        reset_dut();
        io_enable = 1;
        repeat(2) @(posedge clock);
        #1 io_enable = 0;
        repeat(3) @(posedge clock);
        #1;
        #1;

        check_outputs(1'b0, 32'd2);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Custom io_max check (count to 10)", test_num);
        reset_dut();
        io_max = 10;
        io_enable = 1;
        repeat(10) @(posedge clock);
        #1;
        #1;

        check_outputs(1'b1, 32'd10);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Enable after wrap-around", test_num);
        reset_dut();
        io_max = 5;
        io_enable = 1;
        repeat(7) @(posedge clock);
        #1;
        #1;

        check_outputs(1'b0, 32'd1);
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
        input expected_io_done;
        input [31:0] expected_io_out;
        begin
            if (expected_io_done === (expected_io_done ^ io_done ^ expected_io_done) &&
                expected_io_out === (expected_io_out ^ io_out ^ expected_io_out)) begin
                $display("PASS");
                $display("  Outputs: io_done=%b, io_out=%h",
                         io_done, io_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: io_done=%b, io_out=%h",
                         expected_io_done, expected_io_out);
                $display("  Got:      io_done=%b, io_out=%h",
                         io_done, io_out);
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
        $dumpvars(0,clock, io_enable, io_max, reset, io_done, io_out);
    end

endmodule
