`timescale 1ns/1ps

module binary_counter_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg RST;
    wire [3:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    binary_counter dut (
        .CLK(CLK),
        .RST(RST),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

    begin
        @(negedge CLK);
        RST = 1;
        @(negedge CLK);
        RST = 0;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: Initial Reset Check", test_num);
        reset_dut();
        #1;

        check_outputs(4'h0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: Single Increment Check", test_num);
        reset_dut();
        @(negedge CLK);
        #1;

        check_outputs(4'h1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: Multiple Increments Check (7 steps)", test_num);
        reset_dut();
        repeat(7) @(negedge CLK);
        #1;

        check_outputs(4'h7);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: Wraparound Check (16 steps)", test_num);
        reset_dut();
        repeat(16) @(negedge CLK);
        #1;

        check_outputs(4'h0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: Synchronous Reset Mid-count Check", test_num);
        reset_dut();
        repeat(5) @(negedge CLK);
        @(negedge CLK);
        RST = 1;
        @(negedge CLK);
        RST = 0;
        #1;

        check_outputs(4'h0);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("binary_counter Testbench");
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
        input [3:0] expected_Q;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q)) begin
                $display("PASS");
                $display("  Outputs: Q=%h",
                         Q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%h",
                         expected_Q);
                $display("  Got:      Q=%h",
                         Q);
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
        $dumpvars(0,CLK, RST, Q);
    end

endmodule
