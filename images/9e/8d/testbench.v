`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg reset;
    wire cycle_end;
    wire [2:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .enable(enable),
        .reset(reset),
        .cycle_end(cycle_end),
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
            enable = 0;
            @(posedge clk);
            #1;
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset behavior", test_num);
            reset_dut();

            #1;


            check_outputs(1'b0, 3'b000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Counting to S2 (011)", test_num);
            reset_dut();
            enable = 1;
            repeat(3) @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 3'b011);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Full cycle wrap-around and cycle_end assertion", test_num);
            reset_dut();
            enable = 1;
            repeat(4) @(posedge clk);
            #1;


            #1;



            check_outputs(1'b1, 3'b001);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Enable signal pause", test_num);
            reset_dut();
            enable = 1;
            @(posedge clk);
            #1;
            enable = 0;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 3'b001);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset mid-cycle", test_num);
            reset_dut();
            enable = 1;
            repeat(2) @(posedge clk);
            #1;
            reset = 1;
            @(posedge clk);
            #1;
            reset = 0;
            #1;

            check_outputs(1'b0, 3'b000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Multiple full cycles", test_num);
            reset_dut();
            enable = 1;
            repeat(7) @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 3'b001);
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
        input expected_cycle_end;
        input [2:0] expected_q;
        begin
            if (expected_cycle_end === (expected_cycle_end ^ cycle_end ^ expected_cycle_end) &&
                expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: cycle_end=%b, q=%h",
                         cycle_end, q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cycle_end=%b, q=%h",
                         expected_cycle_end, expected_q);
                $display("  Got:      cycle_end=%b, q=%h",
                         cycle_end, q);
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
        $dumpvars(0,clk, enable, reset, cycle_end, q);
    end

endmodule
