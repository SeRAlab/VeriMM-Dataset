`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg clr;
    wire dclk;
    wire segclk;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .clr(clr),
        .dclk(dclk),
        .segclk(segclk)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        clr = 1;
        @(posedge clk);
        #1 clr = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Verify Reset State", test_num);
        reset_dut();


        #1;



        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Verify dclk (q[1]) transitions to 1", test_num);
        reset_dut();


        repeat(1) @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Verify dclk (q[1]) transitions back to 0", test_num);
        reset_dut();




        repeat(3) @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Verify segclk (q[17]) logic", test_num);
        reset_dut();


        repeat(131071) @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1, 1'b1);


    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Verify Mid-count Clear", test_num);
        reset_dut();
        repeat(10) @(posedge clk);
        clr = 1;
        @(posedge clk);
        #1 clr = 0;
        #1;

        check_outputs(1'b0, 1'b0);
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
        input expected_dclk;
        input expected_segclk;
        begin
            if (expected_dclk === (expected_dclk ^ dclk ^ expected_dclk) &&
                expected_segclk === (expected_segclk ^ segclk ^ expected_segclk)) begin
                $display("PASS");
                $display("  Outputs: dclk=%b, segclk=%b",
                         dclk, segclk);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dclk=%b, segclk=%b",
                         expected_dclk, expected_segclk);
                $display("  Got:      dclk=%b, segclk=%b",
                         dclk, segclk);
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
        $dumpvars(0,clk, clr, dclk, segclk);
    end

endmodule
