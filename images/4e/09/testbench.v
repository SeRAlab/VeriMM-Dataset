`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [1:0] ctrl;
    reg [3:0] data_in;
    reg valid;
    wire [3:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .ctrl(ctrl),
        .data_in(data_in),
        .valid(valid),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            valid = 0;
            ctrl = 0;
            data_in = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running Testcase 001: Invert Data");
            reset_dut();
            data_in = 4'b1011;
            ctrl = 2'b00;
            valid = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'b0100);
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase 002: Zero Output");
            reset_dut();
            data_in = 4'b1111;
            ctrl = 2'b01;
            valid = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase003;

        begin
            $display("Running Testcase 003: Masked AND 1010");
            reset_dut();
            data_in = 4'b1111;
            ctrl = 2'b10;
            valid = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'b1010);
        end
        endtask

    task testcase004;

        begin
            $display("Running Testcase 004: Masked AND 0101");
            reset_dut();
            data_in = 4'b1111;
            ctrl = 2'b11;
            valid = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'b0101);
        end
        endtask

    task testcase005;

        begin
            $display("Running Testcase 005: Valid Gating");
            reset_dut();


            data_in = 4'b0000;
            ctrl = 2'b00;
            valid = 1;
            @(posedge clk);
            #1;


            data_in = 4'b1111;
            ctrl = 2'b01;
            valid = 0;
            @(posedge clk);
            #1;


            #1;



            check_outputs(4'b1111);
        end
        endtask

    task testcase006;

        begin
            $display("Running Testcase 006: Invert Zero");
            reset_dut();
            data_in = 4'b0000;
            ctrl = 2'b00;
            valid = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'b1111);
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
        input [3:0] expected_data_out;
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
        $dumpvars(0,clk, ctrl, data_in, valid, data_out);
    end

endmodule
