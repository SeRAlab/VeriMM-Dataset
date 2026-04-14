`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg miso;
    reg reset;
    wire mosi;
    wire ready;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_in(data_in),
        .miso(miso),
        .reset(reset),
        .mosi(mosi),
        .ready(ready)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            data_in = 8'h00;
            miso = 0;
            @(negedge clk);
            reset = 0;
            @(negedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Data 8'hA5 (LSB=1)", test_num);
            data_in = 8'hA5;
            miso = 1;
            reset_dut();

            repeat(8) @(posedge clk);
            #2;

            #1;


            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Data 8'h54 (LSB=0)", test_num);
            data_in = 8'h54;
            miso = 0;
            reset_dut();
            repeat(8) @(posedge clk);
            #2;

            #1;


            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Ones (8'hFF)", test_num);
            data_in = 8'hFF;
            miso = 1;
            reset_dut();
            repeat(8) @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros (8'h00)", test_num);
            data_in = 8'h00;
            miso = 0;
            reset_dut();
            repeat(8) @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Checking ready flag is low mid-transfer", test_num);
            data_in = 8'hAA;
            miso = 1;
            reset_dut();

            repeat(4) @(posedge clk);
            #2;


            #1;



            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating Bits 8'hAA (LSB=0)", test_num);
            data_in = 8'hAA;
            miso = 0;
            reset_dut();
            repeat(8) @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0, 1'b1);
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
        input expected_mosi;
        input expected_ready;
        begin
            if (expected_mosi === (expected_mosi ^ mosi ^ expected_mosi) &&
                expected_ready === (expected_ready ^ ready ^ expected_ready)) begin
                $display("PASS");
                $display("  Outputs: mosi=%b, ready=%b",
                         mosi, ready);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: mosi=%b, ready=%b",
                         expected_mosi, expected_ready);
                $display("  Got:      mosi=%b, ready=%b",
                         mosi, ready);
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
        $dumpvars(0,clk, data_in, miso, reset, mosi, ready);
    end

endmodule
