`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] in;
    wire [3:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in(in),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        in = 16'h0000;
        repeat(5) @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %03d: Basic 0x0000 -> 0xFFFF", test_num);
        reset_dut();

        in = 16'h0000;
        @(posedge clk);
        in = 16'hFFFF;
        @(posedge clk);


        in = 16'h0000;
        @(posedge clk);

        #1;


        check_outputs(4'd1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %03d: Multiple transitions", test_num);
        reset_dut();


        in = 16'h0000; @(posedge clk);
        in = 16'hFFFF; @(posedge clk);


        in = 16'h0000; @(posedge clk);
        in = 16'hFFFF; @(posedge clk);


        in = 16'h0000; @(posedge clk);
        in = 16'hFFFF; @(posedge clk);

        #1;


        check_outputs(4'd3);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %03d: Hold 0xFFFF", test_num);
        reset_dut();

        in = 16'h0000; @(posedge clk);
        in = 16'hFFFF;
        repeat(5) @(posedge clk);

        #1;


        check_outputs(4'd1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %03d: Incomplete transition (not all ones)", test_num);
        reset_dut();

        in = 16'h0000; @(posedge clk);
        in = 16'hFFFE; @(posedge clk);
        in = 16'h0000; @(posedge clk);
        in = 16'h8000; @(posedge clk);

        #1;


        check_outputs(4'd0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %03d: Transition from non-zero to 0xFFFF", test_num);
        reset_dut();

        in = 16'h0001; @(posedge clk);
        in = 16'hFFFF; @(posedge clk);

        #1;


        check_outputs(4'd0);
    end
        endtask

    task testcase006;

    integer i;
    begin
        test_num = test_num + 1;
        $display("Running Testcase %03d: Counter wrap-around (16 transitions)", test_num);
        reset_dut();

        for(i = 0; i < 16; i = i + 1) begin
            in = 16'h0000; @(posedge clk);
            in = 16'hFFFF; @(posedge clk);
        end


        #1;



        check_outputs(4'd0);
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
        input [3:0] expected_out;
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
        $dumpvars(0,clk, in, out);
    end

endmodule
