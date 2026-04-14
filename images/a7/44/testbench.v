`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg direction;
    reg shift_enable;
    reg sreset;
    wire [9:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .direction(direction),
        .shift_enable(shift_enable),
        .sreset(sreset),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        sreset = 1;
        direction = 0;
        shift_enable = 0;
        @(posedge clk);
        #1 sreset = 0;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: Synchronous Reset", test_num);
        reset_dut();

        #1;


        check_outputs(10'h000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: Shift Left (Direction=1)", test_num);
        reset_dut();


        force dut.q = 10'h001;
        @(posedge clk);
        #1 release dut.q;

        direction = 1;
        shift_enable = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(10'h002);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: Shift Right (Direction=0)", test_num);
        reset_dut();


        force dut.q = 10'h200;
        @(posedge clk);
        #1 release dut.q;

        direction = 0;
        shift_enable = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(10'h100);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: Shift Enable Disabled", test_num);
        reset_dut();

        force dut.q = 10'h0AA;
        @(posedge clk);
        #1 release dut.q;

        direction = 1;
        shift_enable = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(10'h0AA);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: Reset Priority over Shifting", test_num);
        reset_dut();

        force dut.q = 10'h3FF;
        @(posedge clk);
        #1 release dut.q;

        sreset = 1;
        shift_enable = 1;
        direction = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(10'h000);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %0d: Multi-bit Shift Left", test_num);
        reset_dut();

        force dut.q = 10'h001;
        @(posedge clk);
        #1 release dut.q;

        direction = 1;
        shift_enable = 1;
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        #1;
        #1;

        check_outputs(10'h008);
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
        input [9:0] expected_q;
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
        $dumpvars(0,clk, direction, shift_enable, sreset, q);
    end

endmodule
