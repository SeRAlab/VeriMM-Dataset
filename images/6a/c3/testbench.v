`timescale 1ns/1ps

module ring_counter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg en;
    reg reset_n;
    wire [8:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ring_counter dut (
        .clk(clk),
        .en(en),
        .reset_n(reset_n),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(negedge clk);
            reset_n = 0;
            en = 0;
            @(negedge clk);
            reset_n = 1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Synchronous Reset Check", test_num);
            reset_dut();

            #1;


            check_outputs(9'h001);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Single Shift Check (en=1)", test_num);
            reset_dut();
            @(negedge clk);
            en = 1;
            @(negedge clk);
            en = 0;
            #1;

            check_outputs(9'h002);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Enable Low Hold Check", test_num);
            reset_dut();
            @(negedge clk);
            en = 1;
            @(negedge clk);
            en = 0;
            repeat(3) @(negedge clk);
            #1;

            check_outputs(9'h002);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shift to MSB (8 cycles)", test_num);
            reset_dut();
            @(negedge clk);
            en = 1;
            repeat(8) @(negedge clk);
            en = 0;
            #1;

            check_outputs(9'h100);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Full Cycle Wraparound Check", test_num);
            reset_dut();
            @(negedge clk);
            en = 1;
            repeat(9) @(negedge clk);
            en = 0;
            #1;

            check_outputs(9'h001);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Mid-sequence Reset Check", test_num);
            reset_dut();
            @(negedge clk);
            en = 1;
            repeat(4) @(negedge clk);
            reset_n = 0;
            @(negedge clk);
            reset_n = 1;
            en = 0;
            #1;

            check_outputs(9'h001);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Multiple Wraparounds Check (19 cycles)", test_num);
            reset_dut();
            @(negedge clk);
            en = 1;
            repeat(19) @(negedge clk);
            en = 0;
            #1;

            check_outputs(9'h002);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ring_counter Testbench");
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
        input [8:0] expected_q;
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
        $dumpvars(0,clk, en, reset_n, q);
    end

endmodule
