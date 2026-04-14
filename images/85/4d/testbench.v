`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clear;
    reg clock;
    reg enable;
    reg reset;
    reg [7:0] shift;
    reg [15:0] x;
    reg [15:0] y;
    wire [15:0] z;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clear(clear),
        .clock(clock),
        .enable(enable),
        .reset(reset),
        .shift(shift),
        .x(x),
        .y(y),
        .z(z)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            reset = 1;
            clear = 0;
            enable = 0;
            shift = 0;
            x = 0;
            y = 0;
            @(posedge clock);
            #1 reset = 0;
            @(posedge clock);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Positive Accumulation", test_num);
            reset_dut();

            @(negedge clock);
            enable = 1;
            x = 16'd10; y = 16'd5;
            @(negedge clock);
            x = 16'd20; y = 16'd3;
            @(negedge clock);
            enable = 0;

            #1;


            check_outputs(16'd110);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Signed Accumulation", test_num);
            reset_dut();

            @(negedge clock);
            enable = 1;
            x = -16'd10; y = 16'd5;
            @(negedge clock);
            x = 16'd5;   y = -16'd2;
            @(negedge clock);
            enable = 0;

            #1;


            check_outputs(-16'd60);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Enable Control", test_num);
            reset_dut();

            @(negedge clock);
            enable = 1;
            x = 16'd100; y = 16'd2;
            @(negedge clock);
            enable = 0;
            x = 16'd50;  y = 16'd2;
            @(negedge clock);
            enable = 1;
            x = 16'd5;   y = 16'd5;
            @(negedge clock);
            enable = 0;

            #1;


            check_outputs(16'd225);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shift Operation", test_num);
            reset_dut();

            @(negedge clock);
            shift = 8;
            enable = 1;


            x = 16'd1024; y = 16'd4;
            @(negedge clock);
            enable = 0;

            #1;


            check_outputs(16'd16);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Clear Operation", test_num);
            reset_dut();

            @(negedge clock);
            enable = 1;
            x = 16'd500; y = 16'd2;
            @(negedge clock);
            clear = 1;
            @(negedge clock);
            clear = 0;
            x = 16'd10; y = 16'd10;
            @(negedge clock);
            enable = 0;

            #1;


            check_outputs(16'd100);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Overflow/Truncation", test_num);
            reset_dut();

            @(negedge clock);
            shift = 0;
            enable = 1;
            x = 16'h7FFF; y = 16'd4;
            @(negedge clock);
            enable = 0;


            #1;



            check_outputs(16'hFFF8);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Multi-cycle with Shift", test_num);
            reset_dut();

            @(negedge clock);
            shift = 4;
            enable = 1;
            x = 16'd100; y = 16'd16;
            @(negedge clock);
            x = 16'd200; y = 16'd16;
            @(negedge clock);
            enable = 0;


            #1;



            check_outputs(16'd300);
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
        input [15:0] expected_z;
        begin
            if (expected_z === (expected_z ^ z ^ expected_z)) begin
                $display("PASS");
                $display("  Outputs: z=%h",
                         z);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: z=%h",
                         expected_z);
                $display("  Got:      z=%h",
                         z);
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
        $dumpvars(0,clear, clock, enable, reset, shift, x, y, z);
    end

endmodule
