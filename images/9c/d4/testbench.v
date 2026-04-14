`timescale 1ns/1ps

module lfsr_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg en;
    wire [11:0] lfsr;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    lfsr dut (
        .clk(clk),
        .en(en),
        .lfsr(lfsr)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            en = 0;
            rst_n = 0;
            @(posedge clk);
            #1 rst_n = 1;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Checking Initial Reset State", test_num);
            reset_dut();

            #1;


            check_outputs(12'hFFF);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Single Shift (en=1 for 1 cycle)", test_num);
            reset_dut();
            en = 1;
            @(posedge clk);
            #1 en = 0;
            #1;

            check_outputs(12'h7FF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Double Shift (en=1 for 2 cycles)", test_num);
            reset_dut();
            en = 1;
            repeat(2) @(posedge clk);
            #1 en = 0;
            #1;

            check_outputs(12'hBFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Enable Control (Check state retention)", test_num);
            reset_dut();
            en = 1;
            repeat(2) @(posedge clk);
            #1 en = 0;
            repeat(3) @(posedge clk);
            #1;

            check_outputs(12'hBFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: 10-Cycle Sequence Verification", test_num);
            reset_dut();
            en = 1;
            repeat(10) @(posedge clk);
            #1 en = 0;
            #1;

            check_outputs(12'h5CB);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("lfsr Testbench");
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
        $dumpvars(0,clk, en, lfsr);
    end

endmodule
