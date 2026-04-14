`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] data;
    reg [31:0] readAddress;
    reg readEnabled;
    reg [31:0] writeAddress;
    reg writeEnabled;
    wire [31:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data(data),
        .readAddress(readAddress),
        .readEnabled(readEnabled),
        .writeAddress(writeAddress),
        .writeEnabled(writeEnabled),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            data = 32'h0;
            readAddress = 32'h0;
            readEnabled = 1'b0;
            writeAddress = 32'h0;
            writeEnabled = 1'b0;
            @(posedge clk);
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Basic Write and Read (Addr 0)", test_num);
            reset_dut();


            writeEnabled = 1'b1;
            writeAddress = 32'h0;
            data = 32'hA5A5A5A5;
            @(posedge clk);
            #2;
            writeEnabled = 1'b0;


            readEnabled = 1'b1;
            readAddress = 32'h0;
            @(negedge clk);
            #2;
            #1;

            check_outputs(32'hA5A5A5A5);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Word Alignment Check", test_num);
            reset_dut();


            writeEnabled = 1'b1;
            writeAddress = 32'h00000004;
            data = 32'h12345678;
            @(posedge clk);
            #2;
            writeEnabled = 1'b0;


            readEnabled = 1'b1;
            readAddress = 32'h00000007;
            @(negedge clk);
            #2;
            #1;

            check_outputs(32'h12345678);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Write Enable Logic Check", test_num);
            reset_dut();


            writeEnabled = 1'b0;
            writeAddress = 32'h00000008;
            data = 32'hFFFFFFFF;
            @(posedge clk);
            #2;


            readEnabled = 1'b1;
            readAddress = 32'h00000008;
            @(negedge clk);
            #2;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Boundary Check (Last Word)", test_num);
            reset_dut();


            writeEnabled = 1'b1;
            writeAddress = 32'h0000007C;
            data = 32'hDEADBEEF;
            @(posedge clk);
            #2;
            writeEnabled = 1'b0;

            readEnabled = 1'b1;
            readAddress = 32'h0000007F;
            @(negedge clk);
            #2;
            #1;

            check_outputs(32'hDEADBEEF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Read Enable Logic Check", test_num);
            reset_dut();


            writeEnabled = 1'b1;
            writeAddress = 32'h00000010;
            data = 32'hCAFEBABE;
            @(posedge clk);
            #2;
            writeEnabled = 1'b0;


            readEnabled = 1'b0;
            readAddress = 32'h00000010;
            @(negedge clk);
            #2;


            if (out !== 32'hCAFEBABE) begin
                pass_count = pass_count + 1;
                $display("PASS: Output did not retrieve data when readEnabled=0");
            end else begin
                fail_count = fail_count + 1;
                $display("FAIL: Output retrieved data even though readEnabled=0");
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
        input [31:0] expected_out;
        begin
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
        $dumpvars(0,clk, data, readAddress, readEnabled, writeAddress, writeEnabled, out);
    end

endmodule
