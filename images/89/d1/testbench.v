`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] d;
    reg pl;
    reg reset;
    wire [3:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .d(d),
        .pl(pl),
        .reset(reset),
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
        pl = 0;
        d = 4'b0;
        @(posedge clk);
        #1;
        reset = 0;
    end
        endtask
    task testcase001;

    begin
        $display("Running testcase001: Reset Check");
        test_num = 1;
        reset_dut();

        #1;


        check_outputs(4'b0000);
    end
        endtask

    task testcase002;

    begin
        $display("Running testcase002: Parallel Load Check");
        test_num = 2;
        reset_dut();
        d = 4'b1010;
        pl = 1;
        @(posedge clk);
        #1;
        pl = 0;
        #1;

        check_outputs(4'b1010);
    end
        endtask

    task testcase003;

    begin
        $display("Running testcase003: Single Left Shift Check");
        test_num = 3;
        reset_dut();

        d = 4'b1000;
        pl = 1;
        @(posedge clk);
        #1;

        pl = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(4'b0001);
    end
        endtask

    task testcase004;

    begin
        $display("Running testcase004: Multiple Shifts Check");
        test_num = 4;
        reset_dut();
        d = 4'b1100;
        pl = 1;
        @(posedge clk);
        #1;
        pl = 0;
        @(posedge clk);
        @(posedge clk);
        #1;
        #1;

        check_outputs(4'b0011);
    end
        endtask

    task testcase005;

    begin
        $display("Running testcase005: Full Rotation Cycle Check");
        test_num = 5;
        reset_dut();
        d = 4'b1011;
        pl = 1;
        @(posedge clk);
        #1;
        pl = 0;
        repeat(4) @(posedge clk);
        #1;
        #1;

        check_outputs(4'b1011);
    end
        endtask

    task testcase006;

    begin
        $display("Running testcase006: Reset Priority Check");
        test_num = 6;
        reset_dut();
        d = 4'b1111;
        pl = 1;
        reset = 1;
        @(posedge clk);
        #1;
        reset = 0;
        pl = 0;
        #1;

        check_outputs(4'b0000);
    end
        endtask

    task testcase007;

    begin
        $display("Running testcase007: Pattern Load Check");
        test_num = 7;
        reset_dut();
        d = 4'b0101;
        pl = 1;
        @(posedge clk);
        #1;
        pl = 0;
        #1;

        check_outputs(4'b0101);
    end
        endtask

    task testcase008;

    begin
        $display("Running testcase008: Load then Shift then Load");
        test_num = 8;
        reset_dut();

        d = 4'b1001;
        pl = 1;
        @(posedge clk);
        #1;

        pl = 0;
        @(posedge clk);
        #1;

        d = 4'b0110;
        pl = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(4'b0110);
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
        testcase008();
        
        
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
        input [3:0] expected_q;
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
        $dumpvars(0,clk, d, pl, reset, q);
    end

endmodule
