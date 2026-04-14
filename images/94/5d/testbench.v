`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg dclk;
    reg rst;
    wire [1:0] control;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .dclk(dclk),
        .rst(rst),
        .control(control)
    );

    // Clock generation (10ns period)
    initial begin
        dclk = 0;
        forever #5 dclk = ~dclk;
    end

        task reset_dut;

    begin
        rst = 1;
        @(posedge dclk);
        #1 rst = 0;
        @(posedge dclk);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Reset State", test_num);
        reset_dut();





        #1;






        check_outputs(2'b00);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Increment to 1", test_num);
        reset_dut();
        @(posedge dclk);
        #1;

        check_outputs(2'b01);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Increment to 2", test_num);
        reset_dut();
        repeat(2) @(posedge dclk);
        #1;

        check_outputs(2'b10);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Increment to 3", test_num);
        reset_dut();
        repeat(3) @(posedge dclk);
        #1;

        check_outputs(2'b11);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Wrap-around to 0", test_num);
        reset_dut();
        repeat(4) @(posedge dclk);
        #1;

        check_outputs(2'b00);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Wrap-around and increment to 1", test_num);
        reset_dut();
        repeat(5) @(posedge dclk);
        #1;

        check_outputs(2'b01);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Multiple cycles (10 steps)", test_num);
        reset_dut();
        repeat(10) @(posedge dclk);

        #1;


        check_outputs(2'b10);
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
        input [1:0] expected_control;
        begin
            if (expected_control === (expected_control ^ control ^ expected_control)) begin
                $display("PASS");
                $display("  Outputs: control=%h",
                         control);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: control=%h",
                         expected_control);
                $display("  Got:      control=%h",
                         control);
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
        $dumpvars(0,dclk, rst, control);
    end

endmodule
