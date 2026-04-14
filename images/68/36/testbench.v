`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg ce;
    reg clk;
    wire [3:0] an;
    wire [1:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ce(ce),
        .clk(clk),
        .an(an),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        $display("Resetting DUT...");
        ce = 0;
        @(posedge clk);
        #1;

        while (q !== 2'b00) begin
            ce = 1;
            @(posedge clk);
            #1;
        end
        ce = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Initial State Check", test_num);
        reset_dut();

        #1;


        check_outputs(4'b1110, 2'b00);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Single Increment", test_num);
        reset_dut();
        ce = 1;
        @(posedge clk);
        #1;
        ce = 0;
        #1;

        check_outputs(4'b1101, 2'b01);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Double Increment", test_num);
        reset_dut();
        ce = 1;
        repeat(2) @(posedge clk);
        #1;
        ce = 0;
        #1;

        check_outputs(4'b1011, 2'b10);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Triple Increment", test_num);
        reset_dut();
        ce = 1;
        repeat(3) @(posedge clk);
        #1;
        ce = 0;
        #1;

        check_outputs(4'b0111, 2'b11);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Wrap-around Increment", test_num);
        reset_dut();
        ce = 1;
        repeat(4) @(posedge clk);
        #1;
        ce = 0;
        #1;

        check_outputs(4'b1110, 2'b00);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Enable/Disable Check", test_num);
        reset_dut();
        ce = 1;
        @(posedge clk);
        #1;
        ce = 0;
        repeat(2) @(posedge clk);
        #1;

        #1;


        check_outputs(4'b1101, 2'b01);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Multiple Wrap-around", test_num);
        reset_dut();
        ce = 1;
        repeat(9) @(posedge clk);
        #1;
        ce = 0;
        #1;

        check_outputs(4'b1101, 2'b01);
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
        input [3:0] expected_an;
        input [1:0] expected_q;
        begin
            if (expected_an === (expected_an ^ an ^ expected_an) &&
                expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: an=%h, q=%h",
                         an, q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: an=%h, q=%h",
                         expected_an, expected_q);
                $display("  Got:      an=%h, q=%h",
                         an, q);
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
        $dumpvars(0,ce, clk, an, q);
    end

endmodule
