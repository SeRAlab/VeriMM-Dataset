`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] data;
    wire [3:0] out_dig;
    wire [7:0] out_seg;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data(data),
        .out_dig(out_dig),
        .out_seg(out_seg)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            data = 16'h0000;
            repeat(2) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            data = 16'h1234;

            repeat(10) @(posedge clk);
            $display("Testcase %0d: Data=0x1234, checking Digit 0 (Value 4)", test_num);

            #1;


            check_outputs(4'b0001, 8'h66);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            data = 16'hABCD;
            repeat(10) @(posedge clk);
            $display("Testcase %0d: Data=0xABCD, checking Digit 0 (Value D)", test_num);

            #1;


            check_outputs(4'b0001, 8'h5E);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            data = 16'hFFFF;
            data = 16'h0000;
            repeat(10) @(posedge clk);
            $display("Testcase %0d: Data=0x0000, checking Digit 0 (Value 0)", test_num);

            #1;


            check_outputs(4'b0001, 8'h3F);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            data = 16'h000F;
            repeat(10) @(posedge clk);
            $display("Testcase %0d: Data=0x000F, checking Digit 0 (Value F)", test_num);

            #1;


            check_outputs(4'b0001, 8'h71);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            data = 16'h1234;
            $display("Testcase %0d: Waiting for refresh cycle to Digit 1 (Value 3)", test_num);

            repeat(50005) @(posedge clk);

            #1;


            check_outputs(4'b0010, 8'h4F);
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
        input [3:0] expected_out_dig;
        input [7:0] expected_out_seg;
        begin
            if (expected_out_dig === (expected_out_dig ^ out_dig ^ expected_out_dig) &&
                expected_out_seg === (expected_out_seg ^ out_seg ^ expected_out_seg)) begin
                $display("PASS");
                $display("  Outputs: out_dig=%h, out_seg=%h",
                         out_dig, out_seg);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_dig=%h, out_seg=%h",
                         expected_out_dig, expected_out_seg);
                $display("  Got:      out_dig=%h, out_seg=%h",
                         out_dig, out_seg);
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
        $dumpvars(0,clk, data, out_dig, out_seg);
    end

endmodule
