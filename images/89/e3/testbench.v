`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg ena;
    reg [31:0] next_in;
    reg reset;
    wire [31:0] current_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .ena(ena),
        .next_in(next_in),
        .reset(reset),
        .current_out(current_out)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            @(posedge clock);
            reset = 1;
            ena = 0;
            next_in = 32'h0;
            @(posedge clock);
            reset = 0;
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Verifying reset state", test_num);
            reset_dut();

            #1;


            check_outputs(32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Loading data with ena=1", test_num);
            reset_dut();
            @(posedge clock);
            ena = 1;
            next_in = 32'hDEADBEEF;
            @(posedge clock);
            #1;
            #1;

            check_outputs(32'hDEADBEEF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Verifying data hold with ena=0", test_num);
            reset_dut();

            @(posedge clock);
            ena = 1;
            next_in = 32'hAAAA5555;
            @(posedge clock);

            ena = 0;
            next_in = 32'hFFFFFFFF;
            @(posedge clock);
            #1;

            #1;


            check_outputs(32'hAAAA5555);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Verifying reset priority over enable", test_num);
            reset_dut();
            @(posedge clock);
            ena = 1;
            reset = 1;
            next_in = 32'h12345678;
            @(posedge clock);
            #1;

            #1;


            check_outputs(32'h00000000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Multiple sequential updates", test_num);
            reset_dut();

            @(posedge clock);
            ena = 1;
            next_in = 32'h11111111;
            @(posedge clock);

            ena = 1;
            next_in = 32'h22222222;
            @(posedge clock);

            ena = 1;
            next_in = 32'h33333333;
            @(posedge clock);
            #1;
            #1;

            check_outputs(32'h33333333);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Loading all ones", test_num);
            reset_dut();
            @(posedge clock);
            ena = 1;
            next_in = 32'hFFFFFFFF;
            @(posedge clock);
            #1;
            #1;

            check_outputs(32'hFFFFFFFF);
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
        input [31:0] expected_current_out;
        begin
            if (expected_current_out === (expected_current_out ^ current_out ^ expected_current_out)) begin
                $display("PASS");
                $display("  Outputs: current_out=%h",
                         current_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: current_out=%h",
                         expected_current_out);
                $display("  Got:      current_out=%h",
                         current_out);
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
        $dumpvars(0,clock, ena, next_in, reset, current_out);
    end

endmodule
