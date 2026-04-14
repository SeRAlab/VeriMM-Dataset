`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] data;
    reg [15:0] dcfilt_coeff;
    reg dcfilt_enb;
    reg [15:0] dcfilt_offset;
    reg valid;
    wire [15:0] data_out;
    wire valid_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data(data),
        .dcfilt_coeff(dcfilt_coeff),
        .dcfilt_enb(dcfilt_enb),
        .dcfilt_offset(dcfilt_offset),
        .valid(valid),
        .data_out(data_out),
        .valid_out(valid_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            valid = 0;
            data = 0;
            dcfilt_enb = 0;
            dcfilt_coeff = 0;
            dcfilt_offset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Running testcase %03d: Filter Disabled", test_num);

            dcfilt_enb = 0;
            dcfilt_offset = 16'h0010;
            data = 16'h0100;
            valid = 1;

            @(posedge clk);
            #2;
            #1;

            check_outputs(16'h00F0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Running testcase %03d: Filter Enabled (Initial Cycle)", test_num);

            dcfilt_enb = 1;
            dcfilt_coeff = 16'h0001;
            data = 16'h0500;
            valid = 1;

            @(posedge clk);
            #2;


            #1;



            check_outputs(16'h0500, 1'b1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Running testcase %03d: Valid Signal Check", test_num);

            dcfilt_enb = 0;
            dcfilt_offset = 16'h0000;
            data = 16'hAAAA;
            valid = 0;

            @(posedge clk);
            #2;
            #1;

            check_outputs(16'hAAAA, 1'b0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Running testcase %03d: Multi-cycle Filtering", test_num);

            dcfilt_enb = 1;
            dcfilt_coeff = 16'h8000;
            data = 16'h1000;
            valid = 1;

            @(posedge clk); #10;
            @(posedge clk); #2;




            if (valid_out === 1'b1) begin
                pass_count = pass_count + 1;
                $display("PASS: Filter valid_out maintained");
            end else begin
                fail_count = fail_count + 1;
                $display("FAIL: Filter valid_out dropped");
            end
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
        input [15:0] expected_data_out;
        input expected_valid_out;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_valid_out === (expected_valid_out ^ valid_out ^ expected_valid_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, valid_out=%b",
                         data_out, valid_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, valid_out=%b",
                         expected_data_out, expected_valid_out);
                $display("  Got:      data_out=%h, valid_out=%b",
                         data_out, valid_out);
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
        $dumpvars(0,clk, data, dcfilt_coeff, dcfilt_enb, dcfilt_offset, valid, data_out, valid_out);
    end

endmodule
