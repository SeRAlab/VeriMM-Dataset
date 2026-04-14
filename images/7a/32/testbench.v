`timescale 1ns/1ps

module bidirectional_counter_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg DIR;
    reg EN;
    reg RST;
    wire [15:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    bidirectional_counter dut (
        .CLK(CLK),
        .DIR(DIR),
        .EN(EN),
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
        RST = 1;
        EN = 0;
        DIR = 0;
        @(negedge CLK);
        RST = 0;
        @(negedge CLK);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Basic Reset", test_num);
        reset_dut();
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Up Counting (10 steps)", test_num);
        reset_dut();
        EN = 1;
        DIR = 1;
        repeat(10) @(negedge CLK);
        EN = 0;
        #1;

        check_outputs(16'd10);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Down Counting Underflow (0 -> FFFF)", test_num);
        reset_dut();
        EN = 1;
        DIR = 0;
        @(negedge CLK);
        EN = 0;
        #1;

        check_outputs(16'hFFFF);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Enable Control (Count then Hold)", test_num);
        reset_dut();
        EN = 1;
        DIR = 1;
        repeat(5) @(negedge CLK);
        EN = 0;
        repeat(5) @(negedge CLK);
        #1;

        check_outputs(16'd5);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Bidirectional Switching (Up 20, Down 5)", test_num);
        reset_dut();
        EN = 1;
        DIR = 1;
        repeat(20) @(negedge CLK);
        DIR = 0;
        repeat(5) @(negedge CLK);
        EN = 0;
        #1;

        check_outputs(16'd15);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Synchronous Reset Priority", test_num);
        reset_dut();
        EN = 1;
        DIR = 1;
        repeat(10) @(negedge CLK);
        RST = 1;
        @(negedge CLK);
        RST = 0;
        EN = 0;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Complex Toggle Sequence", test_num);
        reset_dut();

        EN = 1; DIR = 1;
        repeat(5) @(negedge CLK);

        DIR = 0;
        repeat(3) @(negedge CLK);

        DIR = 1;
        repeat(2) @(negedge CLK);
        EN = 0;
        #1;

        check_outputs(16'd4);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("bidirectional_counter Testbench");
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
        input [15:0] expected_Q;
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
        $dumpvars(0,CLK, DIR, EN, RST, Q);
    end

endmodule
