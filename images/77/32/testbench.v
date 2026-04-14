`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg EN;
    reg clk;
    reg [15:0] in;
    reg [3:0] sel;
    wire [3:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .EN(EN),
        .clk(clk),
        .in(in),
        .sel(sel),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        EN = 0;
        in = 16'h0000;
        sel = 4'h0;


        @(posedge clk);
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        $display("Running testcase001: Enable OFF check");
        reset_dut();
        EN = 0;
        in = 16'hFFFF;
        sel = 4'd0;

        @(posedge clk);
        @(posedge clk);
        #1;
        #1;

        check_outputs(4'h0);
    end
        endtask

    task testcase002;

    begin
        $display("Running testcase002: Select Segment 0 (in[3:0])");
        reset_dut();
        EN = 1;
        in = 16'hABCD;
        sel = 4'd0;
        @(posedge clk);
        @(posedge clk);
        #1;
        #1;

        check_outputs(4'hD);
    end
        endtask

    task testcase003;

    begin
        $display("Running testcase003: Select Segment 1 (in[7:4])");
        reset_dut();
        EN = 1;
        in = 16'hABCD;
        sel = 4'd1;
        @(posedge clk);
        @(posedge clk);
        #1;
        #1;

        check_outputs(4'hC);
    end
        endtask

    task testcase004;

    begin
        $display("Running testcase004: Select Segment 2 (in[11:8])");
        reset_dut();
        EN = 1;
        in = 16'hABCD;
        sel = 4'd2;
        @(posedge clk);
        @(posedge clk);
        #1;
        #1;

        check_outputs(4'hB);
    end
        endtask

    task testcase005;

    begin
        $display("Running testcase005: Select Segment 3 (in[15:12])");
        reset_dut();
        EN = 1;
        in = 16'hABCD;
        sel = 4'd3;
        @(posedge clk);
        @(posedge clk);
        #1;
        #1;

        check_outputs(4'hA);
    end
        endtask

    task testcase006;

    begin
        $display("Running testcase006: Verify Enable signal transition to OFF");
        reset_dut();

        EN = 1;
        in = 16'h1234;
        sel = 4'd2;
        @(posedge clk);
        @(posedge clk);
        #1;

        if (out !== 4'h2) $display("Intermediate setup failed");


        EN = 0;
        @(posedge clk);
        @(posedge clk);
        #1;
        #1;

        check_outputs(4'h0);
    end
        endtask

    task testcase007;

    begin
        $display("Running testcase007: All inputs High check");
        reset_dut();
        EN = 1;
        in = 16'hFFFF;
        sel = 4'd1;
        @(posedge clk);
        @(posedge clk);
        #1;
        #1;

        check_outputs(4'hF);
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
        $dumpvars(0,EN, clk, in, sel, out);
    end

endmodule
