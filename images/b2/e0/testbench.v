`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg d;
    reg [7:0] input2;
    reg [7:0] input3;
    reg [7:0] input4;
    reg reset;
    reg sel_b1;
    reg sel_b2;
    wire [7:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .d(d),
        .input2(input2),
        .input3(input3),
        .input4(input4),
        .reset(reset),
        .sel_b1(sel_b1),
        .sel_b2(sel_b2),
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
        d = 0;
        input2 = 8'h00;
        input3 = 8'h00;
        input4 = 8'h00;
        sel_b1 = 0;
        sel_b2 = 0;
        @(posedge clk);
        #2 reset = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = 1;
        $display("Testcase %03d: Testing selection of input2", test_num);
        input2 = 8'hA5;
        sel_b2 = 0; sel_b1 = 1;
        @(negedge clk);
        #1;

        check_outputs(8'hA5);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = 2;
        $display("Testcase %03d: Testing selection of input3", test_num);
        input3 = 8'h5A;
        sel_b2 = 1; sel_b1 = 0;
        @(negedge clk);
        #1;

        check_outputs(8'h5A);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = 3;
        $display("Testcase %03d: Testing selection of input4", test_num);
        input4 = 8'hFF;
        sel_b2 = 1; sel_b1 = 1;
        @(negedge clk);
        #1;

        check_outputs(8'hFF);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = 4;
        $display("Testcase %03d: Testing Shift Register contents (1-0-1 pattern)", test_num);
        sel_b2 = 0; sel_b1 = 0;


        d = 1; @(posedge clk);

        #1 d = 0; @(posedge clk);

        #1 d = 1; @(posedge clk);


        #1;
        #1;

        check_outputs(8'h05);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = 5;
        $display("Testcase %03d: Testing Shift Register contents (1-1-1 pattern)", test_num);
        sel_b2 = 0; sel_b1 = 0;

        d = 1;
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);

        #1;
        #1;

        check_outputs(8'h07);
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        test_num = 6;
        $display("Testcase %03d: Testing SR shifting while input4 is selected", test_num);

        input4 = 8'hCC;
        sel_b2 = 1; sel_b1 = 1;


        d = 1; @(posedge clk);
        d = 1; @(posedge clk);
        d = 0; @(posedge clk);


        #1 sel_b2 = 0; sel_b1 = 0;
        #1;
        #1;

        check_outputs(8'h06);
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
        input [7:0] expected_q;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%h",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h",
                         expected_q);
                $display("  Got:      q=%h",
                         q);
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
        $dumpvars(0,clk, d, input2, input3, input4, reset, sel_b1, sel_b2, q);
    end

endmodule
