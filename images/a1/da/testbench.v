`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg [31:0] io_in;
    reg reset;
    wire [31:0] io_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .io_in(io_in),
        .reset(reset),
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
            io_in = 32'h0;
            #15;
            reset = 0;
            #5;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Testing Asynchronous Reset", test_num);
            reset_dut();
            #1;

            check_outputs(32'h0000_0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Positive Input (Sign 0) -> Right Shift", test_num);
            reset_dut();
            io_in = 32'h0000_0004;
            @(posedge clock);
            #2;
            #1;

            check_outputs(32'h0000_0002);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Negative Input (Sign 1) -> Left Shift", test_num);
            reset_dut();
            io_in = 32'h8000_0001;
            @(posedge clock);
            #2;
            #1;

            check_outputs(32'h0000_0002);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Boundary Max Positive -> Right Shift", test_num);
            reset_dut();
            io_in = 32'h7FFF_FFFF;
            @(posedge clock);
            #2;
            #1;

            check_outputs(32'h3FFF_FFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: All Ones (Sign 1) -> Left Shift", test_num);
            reset_dut();
            io_in = 32'hFFFF_FFFF;
            @(posedge clock);
            #2;
            #1;

            check_outputs(32'hFFFF_FFFE);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Input Zero (Sign 0) -> Right Shift", test_num);
            reset_dut();
            io_in = 32'h0000_0000;
            @(posedge clock);
            #2;
            #1;

            check_outputs(32'h0000_0000);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Negative Input -> Left Shift to carry bit", test_num);
            reset_dut();
            io_in = 32'hC000_0000;
            @(posedge clock);
            #2;
            #1;

            check_outputs(32'h8000_0000);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Small Positive Input -> Right Shift to Zero", test_num);
            reset_dut();
            io_in = 32'h0000_0001;
            @(posedge clock);
            #2;
            #1;

            check_outputs(32'h0000_0000);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Testcase %0d: Alternating Bits (Sign 1) -> Left Shift", test_num);
            reset_dut();
            io_in = 32'hA5A5_A5A5;
            @(posedge clock);
            #2;
            #1;

            check_outputs(32'h4B4B_4B4A);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Testcase %0d: Alternating Bits (Sign 0) -> Right Shift", test_num);
            reset_dut();
            io_in = 32'h5A5A_5A5A;
            @(posedge clock);
            #2;
            #1;

            check_outputs(32'h2D2D_2D2D);
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
        testcase010();
        
        
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
        input [31:0] expected_io_out;
        begin
            if (expected_io_out === (expected_io_out ^ io_out ^ expected_io_out)) begin
                $display("PASS");
                $display("  Outputs: io_out=%h",
                         io_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: io_out=%h",
                         expected_io_out);
                $display("  Got:      io_out=%h",
                         io_out);
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
        $dumpvars(0,clock, io_in, reset, io_out);
    end

endmodule
