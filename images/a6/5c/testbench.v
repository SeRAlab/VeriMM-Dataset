`timescale 1ns/1ps

module counter_up_down_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg EN;
    reg RST;
    reg UP_DOWN;
    wire [3:0] COUNT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    counter_up_down dut (
        .CLK(CLK),
        .EN(EN),
        .RST(RST),
        .UP_DOWN(UP_DOWN),
        .COUNT(COUNT)
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
        EN = 0;
        UP_DOWN = 0;
        @(negedge CLK);
        RST = 0;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Basic Up Counting (5 steps)", test_num);
        reset_dut();
        @(negedge CLK);
        EN = 1;
        UP_DOWN = 1;
        repeat(5) @(negedge CLK);
        EN = 0;
        #1;

        check_outputs(4'd5);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Basic Down Counting (3 steps from 0)", test_num);
        reset_dut();
        @(negedge CLK);
        EN = 1;
        UP_DOWN = 0;
        repeat(3) @(negedge CLK);
        EN = 0;
        #1;

        check_outputs(4'd13);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Enable Signal Verification", test_num);
        reset_dut();
        @(negedge CLK);
        EN = 1;
        UP_DOWN = 1;
        repeat(2) @(negedge CLK);
        EN = 0;
        repeat(3) @(negedge CLK);
        #1;

        check_outputs(4'd2);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Overflow Roll-over (16 steps)", test_num);
        reset_dut();
        @(negedge CLK);
        EN = 1;
        UP_DOWN = 1;
        repeat(16) @(negedge CLK);
        EN = 0;
        #1;

        check_outputs(4'd0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Underflow Roll-over (1 step from 0)", test_num);
        reset_dut();
        @(negedge CLK);
        EN = 1;
        UP_DOWN = 0;
        repeat(1) @(negedge CLK);
        EN = 0;
        #1;

        check_outputs(4'd15);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Dynamic Direction Change (Up 7, Down 4)", test_num);
        reset_dut();
        @(negedge CLK);
        EN = 1;
        UP_DOWN = 1;
        repeat(7) @(negedge CLK);
        UP_DOWN = 0;
        repeat(4) @(negedge CLK);
        EN = 0;
        #1;

        check_outputs(4'd3);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Synchronous Reset Mid-Count", test_num);
        reset_dut();
        @(negedge CLK);
        EN = 1;
        UP_DOWN = 1;
        repeat(5) @(negedge CLK);
        RST = 1;
        @(negedge CLK);
        RST = 0;
        EN = 0;
        #1;

        check_outputs(4'd0);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("counter_up_down Testbench");
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
        input [3:0] expected_COUNT;
        begin
            if (expected_COUNT === (expected_COUNT ^ COUNT ^ expected_COUNT)) begin
                $display("PASS");
                $display("  Outputs: COUNT=%h",
                         COUNT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: COUNT=%h",
                         expected_COUNT);
                $display("  Got:      COUNT=%h",
                         COUNT);
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
        $dumpvars(0,CLK, EN, RST, UP_DOWN, COUNT);
    end

endmodule
