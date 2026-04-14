`timescale 1ns/1ps

module up_down_counter_4bit_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg EN;
    reg RESET;
    reg UP_DOWN;
    wire [3:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    up_down_counter_4bit dut (
        .CLK(CLK),
        .EN(EN),
        .RESET(RESET),
        .UP_DOWN(UP_DOWN),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

    begin
        RESET = 1;
        EN = 0;
        UP_DOWN = 0;
        #15;
        RESET = 0;
        #5;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Checking asynchronous reset", test_num);
        reset_dut();

        #1;


        check_outputs(4'h0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Counting up 5 times", test_num);
        reset_dut();
        @(posedge CLK);
        EN = 1;
        UP_DOWN = 1;
        repeat (5) @(posedge CLK);
        #1;
        #1;

        check_outputs(4'h5);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Counting down 2 times (0 -> 15 -> 14)", test_num);
        reset_dut();
        @(posedge CLK);
        EN = 1;
        UP_DOWN = 0;
        repeat (2) @(posedge CLK);
        #1;
        #1;

        check_outputs(4'hE);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Disabling counter (EN=0)", test_num);
        reset_dut();
        @(posedge CLK);
        EN = 1; UP_DOWN = 1;
        repeat (3) @(posedge CLK);
        EN = 0;
        repeat (5) @(posedge CLK);
        #1;
        #1;

        check_outputs(4'h3);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Full wrap around up (18 cycles)", test_num);
        reset_dut();
        @(posedge CLK);
        EN = 1;
        UP_DOWN = 1;
        repeat (18) @(posedge CLK);
        #1;
        #1;

        check_outputs(4'h2);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Up 10 steps, then Down 4 steps", test_num);
        reset_dut();
        @(posedge CLK);
        EN = 1;
        UP_DOWN = 1;
        repeat (10) @(posedge CLK);
        UP_DOWN = 0;
        repeat (4) @(posedge CLK);
        #1;
        #1;

        check_outputs(4'h6);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("up_down_counter_4bit Testbench");
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
        $dumpvars(0,CLK, EN, RESET, UP_DOWN, Q);
    end

endmodule
