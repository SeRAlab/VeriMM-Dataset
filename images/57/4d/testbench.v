`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg sharedBit;
    reg sigIn;
    reg [10:0] waitCnt;
    wire sigOut;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .sharedBit(sharedBit),
        .sigIn(sigIn),
        .waitCnt(waitCnt),
        .sigOut(sigOut)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            sigIn = 0;
            sharedBit = 0;
            waitCnt = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Basic functional test (waitCnt=10, sharedBit=1)", test_num);
            reset_dut();
            waitCnt = 11'd10;
            sharedBit = 1'b1;
            @(posedge clk);
            sigIn = 1'b1;
            @(posedge clk);
            sigIn = 1'b0;


            repeat(20) @(posedge clk);

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Basic functional test (waitCnt=5, sharedBit=0)", test_num);
            reset_dut();
            waitCnt = 11'd5;
            sharedBit = 1'b0;
            @(posedge clk);
            sigIn = 1'b1;
            @(posedge clk);
            sigIn = 1'b0;

            repeat(10) @(posedge clk);

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Minimal delay (waitCnt=0)", test_num);
            reset_dut();
            waitCnt = 11'd0;
            sharedBit = 1'b1;
            @(posedge clk);
            sigIn = 1'b1;
            @(posedge clk);
            sigIn = 1'b0;

            repeat(5) @(posedge clk);

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Large delay count (waitCnt=100)", test_num);
            reset_dut();
            waitCnt = 11'd100;
            sharedBit = 1'b1;
            @(posedge clk);
            sigIn = 1'b1;
            @(posedge clk);
            sigIn = 1'b0;

            repeat(110) @(posedge clk);

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Timer reset on re-trigger", test_num);
            reset_dut();
            waitCnt = 11'd20;
            sharedBit = 1'b1;

            @(posedge clk);
            sigIn = 1'b1;
            @(posedge clk);
            sigIn = 1'b0;

            repeat(10) @(posedge clk);


            @(posedge clk);
            sigIn = 1'b1;
            sharedBit = 1'b0;
            @(posedge clk);
            sigIn = 1'b0;



            repeat(25) @(posedge clk);

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Consecutive sigIn pulses", test_num);
            reset_dut();
            waitCnt = 11'd15;
            sharedBit = 1'b1;

            repeat(3) begin
                @(posedge clk);
                sigIn = 1'b1;
                @(posedge clk);
                sigIn = 1'b0;
                repeat(2) @(posedge clk);
            end


            repeat(20) @(posedge clk);
            #1;

            check_outputs(1'b1);
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
        input expected_sigOut;
        begin
            if (expected_sigOut === (expected_sigOut ^ sigOut ^ expected_sigOut)) begin
                $display("PASS");
                $display("  Outputs: sigOut=%b",
                         sigOut);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: sigOut=%b",
                         expected_sigOut);
                $display("  Got:      sigOut=%b",
                         sigOut);
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
        $dumpvars(0,clk, sharedBit, sigIn, waitCnt, sigOut);
    end

endmodule
