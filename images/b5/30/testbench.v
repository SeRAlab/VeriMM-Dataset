`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] w_bus_jump_addr;
    reg w_channel;
    reg w_clock;
    reg w_reset;
    wire [7:0] w_bus_addr_pc_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .w_bus_jump_addr(w_bus_jump_addr),
        .w_channel(w_channel),
        .w_clock(w_clock),
        .w_reset(w_reset),
        .w_bus_addr_pc_out(w_bus_addr_pc_out)
    );

    // Clock generation (10ns period)
    initial begin
        w_clock = 0;
        forever #5 w_clock = ~w_clock;
    end

        task reset_dut;

        begin
            w_reset = 1;
            w_channel = 0;
            w_bus_jump_addr = 8'h00;
            @(posedge w_clock);
            #1;
            w_reset = 0;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Reset and Basic Increment");
            reset_dut();
            repeat (5) @(posedge w_clock);
            #1;
            #1;

            check_outputs(8'd5);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Jump Functionality");
            reset_dut();
            w_bus_jump_addr = 8'hA5;
            w_channel = 1;
            @(posedge w_clock);
            #1;
            w_channel = 0;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Increment after Jump");
            reset_dut();
            w_bus_jump_addr = 8'h10;
            w_channel = 1;
            @(posedge w_clock);
            #1;
            w_channel = 0;
            @(posedge w_clock);
            #1;
            #1;

            check_outputs(8'h11);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Rollover Check");
            reset_dut();
            w_bus_jump_addr = 8'hFF;
            w_channel = 1;
            @(posedge w_clock);
            #1;
            w_channel = 0;
            @(posedge w_clock);
            #1;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Reset Priority");
            reset_dut();

            repeat (2) @(posedge w_clock);
            #1;
            w_reset = 1;
            w_channel = 1;
            w_bus_jump_addr = 8'hEE;
            @(posedge w_clock);
            #1;
            w_reset = 0;
            w_channel = 0;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: Continuous Jump");
            reset_dut();
            w_bus_jump_addr = 8'h33;
            w_channel = 1;
            repeat (3) @(posedge w_clock);
            #1;
            w_channel = 0;
            #1;

            check_outputs(8'h33);
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
        input [7:0] expected_w_bus_addr_pc_out;
        begin
            if (expected_w_bus_addr_pc_out === (expected_w_bus_addr_pc_out ^ w_bus_addr_pc_out ^ expected_w_bus_addr_pc_out)) begin
                $display("PASS");
                $display("  Outputs: w_bus_addr_pc_out=%h",
                         w_bus_addr_pc_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: w_bus_addr_pc_out=%h",
                         expected_w_bus_addr_pc_out);
                $display("  Got:      w_bus_addr_pc_out=%h",
                         w_bus_addr_pc_out);
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
        $dumpvars(0,w_bus_jump_addr, w_channel, w_clock, w_reset, w_bus_addr_pc_out);
    end

endmodule
