`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] progIn;
    wire [7:0] progNum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .progIn(progIn),
        .progNum(progNum)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            progIn = 8'h00;
            repeat(20) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            progIn = 8'hA5;

            repeat(30) @(posedge clk);
            $display("Testcase %0d: Basic stability check", test_num);
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();

            progIn = 8'h11;
            repeat(5) @(posedge clk);

            progIn = 8'h22;
            repeat(30) @(posedge clk);
            $display("Testcase %0d: Glitch rejection check", test_num);

            #1;


            check_outputs(8'h22);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();


            progIn = 8'hCC;
            repeat(30) @(posedge clk);


            progIn = 8'h33;
            repeat(30) @(posedge clk);

            $display("Testcase %0d: Multiple update check", test_num);
            #1;

            check_outputs(8'h33);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();


            progIn = 8'h01; repeat(4) @(posedge clk);
            progIn = 8'h02; repeat(4) @(posedge clk);
            progIn = 8'h03; repeat(4) @(posedge clk);
            progIn = 8'h04; repeat(4) @(posedge clk);


            progIn = 8'hFF;
            repeat(30) @(posedge clk);

            $display("Testcase %0d: Rapid transition timer reset check", test_num);
            #1;

            check_outputs(8'hFF);
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
        input [7:0] expected_progNum;
        begin
            if (expected_progNum === (expected_progNum ^ progNum ^ expected_progNum)) begin
                $display("PASS");
                $display("  Outputs: progNum=%h",
                         progNum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: progNum=%h",
                         expected_progNum);
                $display("  Got:      progNum=%h",
                         progNum);
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
        $dumpvars(0,clk, progIn, progNum);
    end

endmodule
