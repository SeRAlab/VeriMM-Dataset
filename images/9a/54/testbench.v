`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] a;
    reg [7:0] b;
    reg clk;
    wire [2:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .clk(clk),
        .count(count)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        a = 8'h00;
        b = 8'hFF;
        rst = 1;
        @(posedge clk);
        #1 rst = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nRunning testcase%03d: Single Match", test_num);
        reset_dut();
        a = 8'hA1; b = 8'hB1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(3'd1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nRunning testcase%03d: No Match", test_num);
        reset_dut();
        a = 8'h11; b = 8'h12;
        @(posedge clk);
        #1;
        #1;

        check_outputs(3'd0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nRunning testcase%03d: Consecutive Matches", test_num);
        reset_dut();
        a = 8'h05; b = 8'h05;
        @(posedge clk);
        a = 8'h15; b = 8'hF5;
        @(posedge clk);
        a = 8'hAA; b = 8'hBA;
        @(posedge clk);
        #1;
        #1;

        check_outputs(3'd3);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nRunning testcase%03d: High Nibble Independence", test_num);
        reset_dut();
        a = 8'hF1; b = 8'h01;
        @(posedge clk);
        #1;
        #1;

        check_outputs(3'd1);
    end
        endtask

    task testcase005;

    integer i;
    begin
        test_num = test_num + 1;
        $display("\nRunning testcase%03d: Counter Overflow (8 matches)", test_num);
        reset_dut();

        for (i = 0; i < 8; i = i + 1) begin
            a = 8'h00; b = 8'h00;
            @(posedge clk);
        end
        #1;
        #1;

        check_outputs(3'd0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("\nRunning testcase%03d: Intermittent Matches", test_num);
        reset_dut();
        a = 8'h11; b = 8'h21;
        @(posedge clk);
        a = 8'h22; b = 8'h33;
        @(posedge clk);
        a = 8'h44; b = 8'h44;
        @(posedge clk);
        #1;
        #1;

        check_outputs(3'd2);
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
        input [2:0] expected_count;
        begin
            if (expected_count === (expected_count ^ count ^ expected_count)) begin
                $display("PASS");
                $display("  Outputs: count=%h",
                         count);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count=%h",
                         expected_count);
                $display("  Got:      count=%h",
                         count);
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
        $dumpvars(0,a, b, clk, count);
    end

endmodule
