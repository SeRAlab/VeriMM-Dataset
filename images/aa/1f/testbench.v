`timescale 1ns/1ps

module fibonacci_lfsr_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    wire [11:0] lfsr;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fibonacci_lfsr dut (
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
            @(posedge clk);
            reset = 1;
            @(posedge clk);
            #1;
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Checking Reset State", test_num);
            reset_dut();
            #1;

            check_outputs(12'h001);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Single Cycle Transition", test_num);
            reset_dut();
            @(posedge clk);
            #1;
            #1;

            check_outputs(12'h002);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: 4 Cycles Transition (Feedback Trigger)", test_num);
            reset_dut();
            repeat(4) @(posedge clk);
            #1;
            #1;

            check_outputs(12'h011);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: 12 Cycles Transition", test_num);
            reset_dut();
            repeat(12) @(posedge clk);
            #1;
            #1;

            check_outputs(12'h110);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: 20 Cycles Transition", test_num);
            reset_dut();
            repeat(20) @(posedge clk);
            #1;
            #1;

            check_outputs(12'h010);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Mid-run Synchronous Reset", test_num);
            reset_dut();
            repeat(50) @(posedge clk);
            reset_dut();
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
        $display("fibonacci_lfsr Testbench");
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
