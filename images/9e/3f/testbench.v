`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg [12:0] timecode_address;
    reg [7:0] timecode_data;
    reg timecode_valid;
    wire [7:0] data_out;
    wire write_enable;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .reset(reset),
        .timecode_address(timecode_address),
        .timecode_data(timecode_data),
        .timecode_valid(timecode_valid),
        .data_out(data_out),
        .write_enable(write_enable)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            timecode_data = 0;
            timecode_valid = 0;
            timecode_address = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Reset State Verification", test_num);
            reset = 1;
            timecode_data = 8'hFF;
            timecode_valid = 1;
            timecode_address = 13'h1FFF;
            #10;
            #1;

            check_outputs(8'h00, 1'b0);
            reset = 0;
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Valid Write Operation", test_num);
            reset_dut();
            timecode_data = 8'hA5;
            timecode_address = 13'h0123;
            timecode_valid = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hA5, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Read Mode (Valid Low)", test_num);
            reset_dut();
            timecode_data = 8'hBC;
            timecode_address = 13'h0ABC;
            timecode_valid = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h00, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Transition Write to Read", test_num);
            reset_dut();

            timecode_data = 8'hD2;
            timecode_address = 13'h1000;
            timecode_valid = 1;
            @(posedge clk);
            #1;

            timecode_valid = 0;
            timecode_data = 8'h00;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hD2, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Consecutive Writes", test_num);
            reset_dut();


            timecode_data = 8'h11;
            timecode_address = 13'h0001;
            timecode_valid = 1;
            @(posedge clk);


            #1;
            timecode_data = 8'h22;
            timecode_address = 13'h0002;
            timecode_valid = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h22, 1'b1);
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
        input [7:0] expected_data_out;
        input expected_write_enable;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_write_enable === (expected_write_enable ^ write_enable ^ expected_write_enable)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, write_enable=%b",
                         data_out, write_enable);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, write_enable=%b",
                         expected_data_out, expected_write_enable);
                $display("  Got:      data_out=%h, write_enable=%b",
                         data_out, write_enable);
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
        $dumpvars(0,clk, reset, timecode_address, timecode_data, timecode_valid, data_out, write_enable);
    end

endmodule
