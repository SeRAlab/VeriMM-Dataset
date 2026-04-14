`timescale 1ns/1ps

module lfsr_12bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    wire [11:0] lfsr;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    lfsr_12bit dut (
        .clk(clk),
        .reset(reset),
        .lfsr(lfsr)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            @(posedge clk);
            #1;
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            $display("Test Case %0d: Reset State Check", test_num);
            #1;

            check_outputs(12'h001);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            @(posedge clk);
            #1;
            $display("Test Case %0d: State After 1 Cycle", test_num);
            #1;

            check_outputs(12'h002);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            repeat(5) @(posedge clk);
            #1;
            $display("Test Case %0d: State After 5 Cycles", test_num);
            #1;

            check_outputs(12'h020);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            repeat(11) @(posedge clk);
            #1;
            $display("Test Case %0d: State After 11 Cycles (MSB set)", test_num);
            #1;

            check_outputs(12'h800);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            repeat(12) @(posedge clk);
            #1;
            $display("Test Case %0d: State After 12 Cycles (XOR Feedback Active)", test_num);
            #1;

            check_outputs(12'h001);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            repeat(13) @(posedge clk);
            #1;
            $display("Test Case %0d: State After 13 Cycles", test_num);
            #1;

            check_outputs(12'h002);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            repeat(23) @(posedge clk);
            #1;
            $display("Test Case %0d: State After 23 Cycles", test_num);
            #1;

            check_outputs(12'h800);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            reset_dut();
            repeat(24) @(posedge clk);
            #1;
            $display("Test Case %0d: State After 24 Cycles", test_num);
            #1;

            check_outputs(12'h001);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("lfsr_12bit Testbench");
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
        input [11:0] expected_lfsr;
        begin
            if (expected_lfsr === (expected_lfsr ^ lfsr ^ expected_lfsr)) begin
                $display("PASS");
                $display("  Outputs: lfsr=%h",
                         lfsr);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: lfsr=%h",
                         expected_lfsr);
                $display("  Got:      lfsr=%h",
                         lfsr);
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
        $dumpvars(0,clk, reset, lfsr);
    end

endmodule
