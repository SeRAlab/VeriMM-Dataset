`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg PB;
    wire PB_down;
    wire PB_state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .PB(PB),
        .PB_down(PB_down),
        .PB_state(PB_state)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            PB = 0;

            repeat(500) @(posedge CLK);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            $display("Testcase %03d: Valid long press (400 cycles)", test_num);
            PB = 1;
            repeat(400) @(posedge CLK);
            #1;
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            $display("Testcase %03d: Short noise glitch (200 cycles)", test_num);
            PB = 1;
            repeat(200) @(posedge CLK);
            PB = 0;
            repeat(100) @(posedge CLK);
            #1;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            $display("Testcase %03d: Button release after stable press", test_num);
            PB = 1;
            repeat(450) @(posedge CLK);
            PB = 0;
            repeat(450) @(posedge CLK);
            #1;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            $display("Testcase %03d: Bouncing input", test_num);
            PB = 1; repeat(50) @(posedge CLK);
            PB = 0; repeat(50) @(posedge CLK);
            PB = 1; repeat(50) @(posedge CLK);
            PB = 0; repeat(20) @(posedge CLK);
            PB = 1;
            repeat(400) @(posedge CLK);
            #1;
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            $display("Testcase %03d: Boundary check (399 cycles)", test_num);
            PB = 1;
            repeat(399) @(posedge CLK);
            #1;
            #1;

            check_outputs(1'b0, 1'b0);
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
        input expected_PB_down;
        input expected_PB_state;
        begin
            if (expected_PB_down === (expected_PB_down ^ PB_down ^ expected_PB_down) &&
                expected_PB_state === (expected_PB_state ^ PB_state ^ expected_PB_state)) begin
                $display("PASS");
                $display("  Outputs: PB_down=%b, PB_state=%b",
                         PB_down, PB_state);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: PB_down=%b, PB_state=%b",
                         expected_PB_down, expected_PB_state);
                $display("  Got:      PB_down=%b, PB_state=%b",
                         PB_down, PB_state);
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
        $dumpvars(0,CLK, PB, PB_down, PB_state);
    end

endmodule
