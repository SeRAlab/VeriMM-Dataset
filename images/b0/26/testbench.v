`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] data_in;
    wire [7:0] crc_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_in(data_in),
        .crc_out(crc_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            data_in = 16'h0000;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            data_in = 16'h0000;
            @(posedge clk);
            #2;
            $display("Test %0d: All Zeros (16'h0000)", test_num);
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            data_in = 16'hFFFF;
            @(posedge clk);
            #2;
            $display("Test %0d: All Ones (16'hFFFF)", test_num);

            #1;


            check_outputs(8'hAC);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            data_in = 16'h0001;
            @(posedge clk);
            #2;
            $display("Test %0d: Single Bit LSB (16'h0001)", test_num);
            #1;

            check_outputs(8'h07);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            data_in = 16'hAAAA;
            @(posedge clk);
            #2;
            $display("Test %0d: Alternating Bits (16'hAAAA)", test_num);
            #1;

            check_outputs(8'h4A);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            data_in = 16'h1234;
            @(posedge clk);
            #2;
            $display("Test %0d: Arbitrary Data (16'h1234)", test_num);
            #1;

            check_outputs(8'h7E);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_dut();
            data_in = 16'h8000;
            @(posedge clk);
            #2;
            $display("Test %0d: High Bit MSB (16'h8000)", test_num);
            #1;

            check_outputs(8'hD5);
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
        input [7:0] expected_crc_out;
        begin
            if (expected_crc_out === (expected_crc_out ^ crc_out ^ expected_crc_out)) begin
                $display("PASS");
                $display("  Outputs: crc_out=%h",
                         crc_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: crc_out=%h",
                         expected_crc_out);
                $display("  Got:      crc_out=%h",
                         crc_out);
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
        $dumpvars(0,clk, data_in, crc_out);
    end

endmodule
