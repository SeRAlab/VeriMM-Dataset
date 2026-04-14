`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [10:0] data_in;
    reg load;
    reg reset;
    wire [10:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_in(data_in),
        .load(load),
        .reset(reset),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(posedge clk);
            reset = 1;
            load = 0;
            data_in = 0;
            @(posedge clk);
            #1 reset = 0;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Verify Reset");
            reset_dut();
            #1;

            check_outputs(11'h000);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Parallel Load");
            reset_dut();
            load = 1;
            data_in = 11'h5AA;
            @(posedge clk);
            #1;
            load = 0;
            #1;

            check_outputs(11'h5AA);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Single Shift Left");
            reset_dut();

            load = 1;
            data_in = 11'h001;
            @(posedge clk);
            #1;
            load = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(11'h002);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Multiple Shifts Left");
            reset_dut();
            load = 1;
            data_in = 11'h007;
            @(posedge clk);
            #1;
            load = 0;
            repeat(4) @(posedge clk);
            #1;

            #1;


            check_outputs(11'h070);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Shift MSB Out");
            reset_dut();
            load = 1;
            data_in = 11'h400;
            @(posedge clk);
            #1;
            load = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(11'h000);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Reset Priority Over Load");
            reset_dut();
            load = 1;
            reset = 1;
            data_in = 11'h7FF;
            @(posedge clk);
            #1;
            reset = 0;
            load = 0;
            #1;

            check_outputs(11'h000);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Shift All Bits Out");
            reset_dut();
            load = 1;
            data_in = 11'h7FF;
            @(posedge clk);
            #1;
            load = 0;
            repeat(11) @(posedge clk);
            #1;
            #1;

            check_outputs(11'h000);
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
        input [10:0] expected_q;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%h",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h",
                         expected_q);
                $display("  Got:      q=%h",
                         q);
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
        $dumpvars(0,clk, data_in, load, reset, q);
    end

endmodule
