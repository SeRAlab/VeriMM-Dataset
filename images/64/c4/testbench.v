`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] a;
    reg [7:0] b;
    reg [7:0] c;
    reg clk;
    reg [7:0] d;
    reg [99:0] data;
    reg [1:0] ena;
    reg reset;
    reg select;
    wire [7:0] min;
    wire [99:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .c(c),
        .clk(clk),
        .d(d),
        .data(data),
        .ena(ena),
        .reset(reset),
        .select(select),
        .min(min),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        a = 0; b = 0; c = 0; d = 0;
        data = 0; ena = 0; select = 0;
        @(posedge clk);
        #1 reset = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        reset_dut();
        select = 1;
        a = 8'h05; b = 8'h10; c = 8'h20; d = 8'h30;
        @(posedge clk);
        #1 #1;
 check_outputs(8'h05, 100'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        reset_dut();
        select = 1;
        a = 8'hFF; b = 8'hEE; c = 8'hDD; d = 8'h01;
        @(posedge clk);
        #1 #1;
 check_outputs(8'h01, 100'd0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        reset_dut();
        select = 0;
        ena = 2'b00;
        data = 100'hFEDCBA9876543210FEDCBA987;
        @(posedge clk);
        #1 #1;
 check_outputs(8'h00, 100'hFEDCBA9876543210FEDCBA987);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        reset_dut();
        select = 0;

        ena = 2'b00;
        data = 100'h1;
        @(posedge clk);

        ena = 2'b01;
        @(posedge clk);
        #1 #1;
 check_outputs(8'h00, 100'h2);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        reset_dut();
        select = 0;

        ena = 2'b00;
        data = 100'h2;
        @(posedge clk);

        ena = 2'b10;
        @(posedge clk);
        #1 #1;
 check_outputs(8'h00, 100'h1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        reset_dut();
        select = 0;

        ena = 2'b00;
        data = 100'hFF00;
        @(posedge clk);

        ena = 2'b11;
        @(posedge clk);
        #1 #1;
 check_outputs(8'h00, 100'hFF);
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
        input [7:0] expected_min;
        input [99:0] expected_q;
        begin
            if (expected_min === (expected_min ^ min ^ expected_min) &&
                expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: min=%h, q=%h",
                         min, q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: min=%h, q=%h",
                         expected_min, expected_q);
                $display("  Got:      min=%h, q=%h",
                         min, q);
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
        $dumpvars(0,a, b, c, clk, d, data, ena, reset, select, min, q);
    end

endmodule
