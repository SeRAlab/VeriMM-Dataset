`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] divFactor;
    wire divClk;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .divFactor(divFactor),
        .divClk(divClk)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            divFactor = 8'd0;


            repeat(2) @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: divFactor = 1 (Divide by 2)");
            test_num = 1;
            reset_dut();
            divFactor = 8'd1;
            repeat(10) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: divFactor = 2 (Divide by 4)");
            test_num = 2;
            reset_dut();
            divFactor = 8'd2;
            repeat(20) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: divFactor = 3 (Divide by 8)");
            test_num = 3;
            reset_dut();
            divFactor = 8'd3;
            repeat(40) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: divFactor = 4 (Divide by 16)");
            test_num = 4;
            reset_dut();
            divFactor = 8'd4;
            repeat(80) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: divFactor = 5 (Divide by 32)");
            test_num = 5;
            reset_dut();
            divFactor = 8'd5;
            repeat(160) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
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
        input expected_divClk;
        begin
            if (expected_divClk === (expected_divClk ^ divClk ^ expected_divClk)) begin
                $display("PASS");
                $display("  Outputs: divClk=%b",
                         divClk);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: divClk=%b",
                         expected_divClk);
                $display("  Got:      divClk=%b",
                         divClk);
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
        $dumpvars(0,clk, divFactor, divClk);
    end

endmodule
