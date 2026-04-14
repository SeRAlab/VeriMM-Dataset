`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg data_in;
    reg load;
    reg reset;
    reg shift_in;
    wire [7:0] data_out;

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
        .shift_in(shift_in),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            load = 0;
            data_in = 0;
            shift_in = 0;
            @(posedge clk);
            #1;
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Reset Check");
            reset_dut();

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Load bit 1");
            reset_dut();
            load = 1;
            data_in = 1;
            @(posedge clk);
            #1;
            load = 0;

            #1;


            check_outputs(8'h01);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Shift left multiple times");
            reset_dut();
            shift_in = 1;
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h07);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Shift mixed bits");
            reset_dut();

            shift_in = 1; @(posedge clk);
            shift_in = 0; @(posedge clk);
            shift_in = 1; @(posedge clk);
            shift_in = 1; @(posedge clk);
            #1;

            #1;


            check_outputs(8'h0B);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Reset priority over Load");
            reset_dut();
            load = 1;
            data_in = 1;
            reset = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h00);
            reset = 0;
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: Fill and overflow check");
            reset_dut();
            shift_in = 1;
            repeat(8) @(posedge clk);
            shift_in = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hFE);
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
        input [7:0] expected_data_out;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h",
                         expected_data_out);
                $display("  Got:      data_out=%h",
                         data_out);
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
        $dumpvars(0,clk, data_in, load, reset, shift_in, data_out);
    end

endmodule
