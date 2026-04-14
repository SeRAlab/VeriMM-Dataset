`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg pin_dir;
    reg [3:0] pin_name;
    reg pin_state;
    reg rst;
    wire [19:0] pin_states;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .pin_dir(pin_dir),
        .pin_name(pin_name),
        .pin_state(pin_state),
        .rst(rst),
        .pin_states(pin_states)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            pin_dir = 0;
            pin_name = 0;
            pin_state = 0;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Reset behavior");
            reset_dut();
            #1;

            check_outputs(20'bzzzz_zzzz_zzzz_zzzz_zzzz);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Set Pin 0 to Output High");
            reset_dut();
            pin_name = 4'd0;
            pin_dir = 1'b1;
            pin_state = 1'b1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(20'bzzzz_zzzz_zzzz_zzzz_zzz1);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Set Pin 5 to Output Low");
            reset_dut();
            pin_name = 4'd5;
            pin_dir = 1'b1;
            pin_state = 1'b0;
            @(posedge clk);
            #2;

            #1;


            check_outputs(20'bzzzz_zzzz_zzzz_zz0z_zzzz);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Multiple Pin Configuration");
            reset_dut();


            pin_name = 4'd2; pin_dir = 1'b1; pin_state = 1'b1;
            @(posedge clk);


            #1; pin_name = 4'd10; pin_dir = 1'b1; pin_state = 1'b0;
            @(posedge clk);


            #1; pin_name = 4'd15; pin_dir = 1'b1; pin_state = 1'b1;
            @(posedge clk);

            #2;

            #1;


            check_outputs(20'bzzzz_1zzz_zz0z_zzzz_z1zz);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Output to Input transition");
            reset_dut();


            pin_name = 4'd8; pin_dir = 1'b1; pin_state = 1'b1;
            @(posedge clk);
            #1;


            pin_name = 4'd8; pin_dir = 1'b0;
            @(posedge clk);

            #2;
            #1;

            check_outputs(20'bzzzz_zzzz_zzzz_zzzz_zzzz);
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
        input [19:0] expected_pin_states;
        begin
            if (expected_pin_states === (expected_pin_states ^ pin_states ^ expected_pin_states)) begin
                $display("PASS");
                $display("  Outputs: pin_states=%h",
                         pin_states);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pin_states=%h",
                         expected_pin_states);
                $display("  Got:      pin_states=%h",
                         pin_states);
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
        $dumpvars(0,clk, pin_dir, pin_name, pin_state, rst, pin_states);
    end

endmodule
