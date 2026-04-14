`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] a_d;
    reg clock;
    reg reset;
    reg statecase;
    reg [7:0] x_d;
    reg [7:0] y_d;
    wire [7:0] z_d;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a_d(a_d),
        .clock(clock),
        .reset(reset),
        .statecase(statecase),
        .x_d(x_d),
        .y_d(y_d),
        .z_d(z_d)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            reset = 1;
            a_d = 0;
            x_d = 0;
            y_d = 0;
            statecase = 0;
            @(posedge clock);
            #2;
            reset = 0;
            @(posedge clock);
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Operation with reset value (a_d_stored = 0)", test_num);
            reset_dut();
            x_d = 8'd10;
            y_d = 8'd5;
            statecase = 1;
            #5;
            #1;

            check_outputs(8'd5);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Basic multiply-add (a_d_stored = 5)", test_num);
            reset_dut();
            a_d = 8'd5;
            @(posedge clock);
            #2;
            x_d = 8'd2;
            y_d = 8'd3;
            statecase = 1;
            #5;
            #1;

            check_outputs(8'd13);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Overflow handling (Result > 255)", test_num);
            reset_dut();
            a_d = 8'd50;
            @(posedge clock);
            #2;
            x_d = 8'd5;
            y_d = 8'd10;
            statecase = 1;
            #5;
            #1;

            check_outputs(8'd4);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Zero multiplication", test_num);
            reset_dut();
            a_d = 8'd100;
            @(posedge clock);
            #2;
            x_d = 8'd0;
            y_d = 8'd25;
            statecase = 1;
            #5;
            #1;

            check_outputs(8'd25);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Sequential a_d capture verification", test_num);
            reset_dut();
            a_d = 8'd7;
            @(posedge clock);
            #2;
            a_d = 8'd20;
            x_d = 8'd3;
            y_d = 8'd1;
            statecase = 1;
            #5;
            #1;

            check_outputs(8'd22);
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
        input [7:0] expected_z_d;
        begin
            if (expected_z_d === (expected_z_d ^ z_d ^ expected_z_d)) begin
                $display("PASS");
                $display("  Outputs: z_d=%h",
                         z_d);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: z_d=%h",
                         expected_z_d);
                $display("  Got:      z_d=%h",
                         z_d);
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
        $dumpvars(0,a_d, clock, reset, statecase, x_d, y_d, z_d);
    end

endmodule
