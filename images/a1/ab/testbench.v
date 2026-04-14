`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] addr;
    reg byte_op;
    reg clk;
    reg [15:0] data_in;
    reg rd;
    reg reset;
    reg wr;
    wire [15:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr(addr),
        .byte_op(byte_op),
        .clk(clk),
        .data_in(data_in),
        .rd(rd),
        .reset(reset),
        .wr(wr),
        .data_out(data_out)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test 001: Basic Word Write and Read");

        reset = 1; rd = 0; wr = 0; addr = 0; data_in = 0; byte_op = 0;
        @(posedge clk);
        #2 reset = 0;


        @(posedge clk);
        #2 addr = 16'h0100; data_in = 16'hABCD; wr = 1; byte_op = 0;
        @(posedge clk);
        #2 wr = 0;


        @(posedge clk);
        #2 rd = 1; addr = 16'h0100;
        @(posedge clk);
        #2;
        #1;

        check_outputs(16'hABCD);
        rd = 0;
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test 002: High Address Boundary Test");
        reset = 1;
        @(posedge clk);
        #2 reset = 0;


        @(posedge clk);
        #2 addr = 16'h7FFF; data_in = 16'h55AA; wr = 1; byte_op = 0;
        @(posedge clk);
        #2 wr = 0;


        @(posedge clk);
        #2 rd = 1; addr = 16'h7FFF;
        @(posedge clk);
        #2;
        #1;

        check_outputs(16'h55AA);
        rd = 0;
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test 003: Byte Operation Test");
        reset = 1;
        @(posedge clk);
        #2 reset = 0;


        @(posedge clk);
        #2 addr = 16'h0010; data_in = 16'hFFFF; wr = 1; byte_op = 0;
        @(posedge clk);
        #2 wr = 0;


        @(posedge clk);
        #2 addr = 16'h0010; data_in = 16'h1200; wr = 1; byte_op = 1;
        @(posedge clk);
        #2 wr = 0; byte_op = 0;


        @(posedge clk);
        #2 rd = 1; addr = 16'h0010;
        @(posedge clk);
        #2;


        if (data_out != 16'hFFFF) begin
            pass_count = pass_count + 1;
            $display("PASS: Byte operation modified the data. Got: %h", data_out);
        end else begin
            fail_count = fail_count + 1;
            $display("FAIL: Byte operation failed to modify data.");
        end
        rd = 0;
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test 004: Reset during Read Operation");
        reset = 1;
        @(posedge clk);
        #2 reset = 0;


        @(posedge clk);
        #2 addr = 16'h0005; data_in = 16'h1234; wr = 1;
        @(posedge clk);
        #2 wr = 0; rd = 1;


        @(posedge clk);
        #2 reset = 1;
        @(posedge clk);
        #2;

        #1;


        check_outputs(16'h0000);
        reset = 0;
        rd = 0;
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test 005: Sequential Word Access");
        reset = 1;
        @(posedge clk);
        #2 reset = 0;


        @(posedge clk);
        #2 addr = 16'h0001; data_in = 16'h1111; wr = 1;

        @(posedge clk);
        #2 addr = 16'h0002; data_in = 16'h2222; wr = 1;
        @(posedge clk);
        #2 wr = 0;


        @(posedge clk);
        #2 rd = 1; addr = 16'h0001;
        @(posedge clk);
        #2 $display("Reading Addr 1...");


        @(posedge clk);
        #2 addr = 16'h0002;
        @(posedge clk);
        #2;
        #1;

        check_outputs(16'h2222);
        rd = 0;
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
        input [15:0] expected_data_out;
        begin
            #1; // Small delay for combinational logic to settle
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

endmodule
