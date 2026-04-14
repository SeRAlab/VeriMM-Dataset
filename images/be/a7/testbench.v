`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] in;
    reg ld;
    reg reset;
    wire [31:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in(in),
        .ld(ld),
        .reset(reset),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 0;
        ld = 0;
        in = 0;
        @(posedge clk);
        #1;
        reset = 1;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: Reset Check", test_num);
        reset_dut();


        #1;



        check_outputs(32'h00000000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: Increment Check (3 cycles)", test_num);
        reset_dut();
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        #1;
        #1;

        check_outputs(32'd12);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: Load Check", test_num);
        reset_dut();
        in = 32'hA5A5A5A5;
        ld = 1;
        @(posedge clk);
        #1;
        ld = 0;
        #1;

        check_outputs(32'hA5A5A5A5);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: Load then Increment Check", test_num);
        reset_dut();
        in = 32'h00001000;
        ld = 1;
        @(posedge clk);
        #1;
        ld = 0;
        @(posedge clk);
        @(posedge clk);
        #1;
        #1;

        check_outputs(32'h00001008);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: Reset Priority Check", test_num);
        reset_dut();
        in = 32'hFFFFFFFF;
        ld = 1;
        reset = 0;
        @(posedge clk);
        #1;
        reset = 1;
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %0d: Wraparound Check", test_num);
        reset_dut();
        in = 32'hFFFFFFFC;
        ld = 1;
        @(posedge clk);
        #1;
        ld = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test %0d: Load Zero then Increment", test_num);
        reset_dut();
        in = 32'h00000000;
        ld = 1;
        @(posedge clk);
        #1;
        ld = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(32'h00000004);
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
        testcase007();
        
        
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
        $dumpvars(0,clk, in, ld, reset, out);
    end

endmodule
