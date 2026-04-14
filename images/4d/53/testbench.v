`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg Clock_Board;
    reg resetn;
    wire Main_clock;
    wire VGA_clock;
    wire locked;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Clock_Board(Clock_Board),
        .resetn(resetn),
        .Main_clock(Main_clock),
        .VGA_clock(VGA_clock),
        .locked(locked)
    );

    // Clock generation (10ns period)
    initial begin
        resetn = 0;
        forever #5 resetn = ~resetn;
    end

        task reset_dut;

        begin
            resetn = 0;
            #100;
            resetn = 1;
            #20;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Checking Reset State", test_num);
            resetn = 0;
            #100;


            #1;



            check_outputs(1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Checking Locked Signal Stability", test_num);
            reset_dut();


            #1000;



            @(posedge Clock_Board);
            #1;
            #1;

            check_outputs(Main_clock, VGA_clock, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Reset Re-assertion Test", test_num);


            resetn = 1;
            #500;


            resetn = 0;
            #50;


            #1;



            check_outputs(Main_clock, VGA_clock, 1'b0);
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
        input expected_Main_clock;
        input expected_VGA_clock;
        input expected_locked;
        begin
            if (expected_Main_clock === (expected_Main_clock ^ Main_clock ^ expected_Main_clock) &&
                expected_VGA_clock === (expected_VGA_clock ^ VGA_clock ^ expected_VGA_clock) &&
                expected_locked === (expected_locked ^ locked ^ expected_locked)) begin
                $display("PASS");
                $display("  Outputs: Main_clock=%b, VGA_clock=%b, locked=%b",
                         Main_clock, VGA_clock, locked);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Main_clock=%b, VGA_clock=%b, locked=%b",
                         expected_Main_clock, expected_VGA_clock, expected_locked);
                $display("  Got:      Main_clock=%b, VGA_clock=%b, locked=%b",
                         Main_clock, VGA_clock, locked);
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
        $dumpvars(0,Clock_Board, resetn, Main_clock, VGA_clock, locked);
    end

endmodule
