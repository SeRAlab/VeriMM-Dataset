`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] in;
    reg nibble;
    reg noswap;
    wire [31:0] out;
    wire [31:0] swapped;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in(in),
        .nibble(nibble),
        .noswap(noswap),
        .out(out),
        .swapped(swapped)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        in = 32'h0;
        nibble = 0;
        noswap = 1;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = 1;
        in = 32'h12345678;
        noswap = 1;
        nibble = 0;
        @(posedge clk);
        #2;

        #1;


        check_outputs(32'h12345678, 32'h12345678);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = 2;
        in = 32'h11223344;
        noswap = 0;
        nibble = 0;
        @(posedge clk);
        #2;

        #1;


        check_outputs(32'h44332211, 32'h44332211);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = 3;
        in = 32'h12345678;
        noswap = 0;
        nibble = 1;
        @(posedge clk);
        #2;

        #1;


        check_outputs(32'h21436587, 32'h21436587);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = 4;
        in = 32'hFFFFFFFF;
        noswap = 0;
        nibble = 0;
        @(posedge clk);
        #2;
        #1;

        check_outputs(32'hFFFFFFFF, 32'hFFFFFFFF);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = 5;
        in = 32'hA5A55A5A;
        noswap = 0;
        nibble = 1;
        @(posedge clk);
        #2;

        #1;


        check_outputs(32'h5A5AA5A5, 32'h5A5AA5A5);
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        test_num = 6;
        in = 32'hDEADC0DE;
        noswap = 1;
        nibble = 1;
        @(posedge clk);
        #2;
        #1;

        check_outputs(32'hDEADC0DE, 32'hDEADC0DE);
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
        input [31:0] expected_out;
        input [31:0] expected_swapped;
        begin
            if (expected_out === (expected_out ^ out ^ expected_out) &&
                expected_swapped === (expected_swapped ^ swapped ^ expected_swapped)) begin
                $display("PASS");
                $display("  Outputs: out=%h, swapped=%h",
                         out, swapped);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h, swapped=%h",
                         expected_out, expected_swapped);
                $display("  Got:      out=%h, swapped=%h",
                         out, swapped);
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
        $dumpvars(0,clk, in, nibble, noswap, out, swapped);
    end

endmodule
