`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg INPUT1;
    reg INPUT2;
    reg INPUT3;
    reg INPUT4;
    reg PB_DOWN;
    reg PB_UP;
    reg SLOW_CLOCK;
    reg SW14;
    reg SW6;
    reg SW7;
    wire Z;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .INPUT1(INPUT1),
        .INPUT2(INPUT2),
        .INPUT3(INPUT3),
        .INPUT4(INPUT4),
        .PB_DOWN(PB_DOWN),
        .PB_UP(PB_UP),
        .SLOW_CLOCK(SLOW_CLOCK),
        .SW14(SW14),
        .SW6(SW6),
        .SW7(SW7),
        .Z(Z)
    );

    // Clock generation (10ns period)
    initial begin
        SLOW_CLOCK = 0;
        forever #5 SLOW_CLOCK = ~SLOW_CLOCK;
    end

        task reset_dut;

        begin
            INPUT1 = 0; INPUT2 = 0; INPUT3 = 0; INPUT4 = 0;
            PB_DOWN = 0; PB_UP = 0; SW14 = 0; SW6 = 0; SW7 = 0;

            repeat(2) @(posedge SLOW_CLOCK);
            #1;
        end
        endtask
    task pulse_up;

        begin
            PB_UP = 1;
            @(posedge SLOW_CLOCK);
            #1 PB_UP = 0;
            @(posedge SLOW_CLOCK);
            #1;
        end
        endtask

    task pulse_down;

        begin
            PB_DOWN = 1;
            @(posedge SLOW_CLOCK);
            #1 PB_DOWN = 0;
            @(posedge SLOW_CLOCK);
            #1;
        end
        endtask

    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Initial state (Select 0)", test_num);
            reset_dut();
            INPUT1 = 1; INPUT2 = 0; INPUT3 = 0; INPUT4 = 0;
            #5;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Increment to Select 1", test_num);
            reset_dut();
            SW6 = 1; SW7 = 1; SW14 = 1;
            INPUT1 = 0; INPUT2 = 1; INPUT3 = 0; INPUT4 = 0;
            pulse_up();
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Increment to Select 2", test_num);
            reset_dut();
            SW6 = 1; SW7 = 1; SW14 = 1;
            INPUT1 = 0; INPUT2 = 0; INPUT3 = 1; INPUT4 = 0;
            pulse_up();
            pulse_up();
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Increment to Select 3", test_num);
            reset_dut();
            SW6 = 1; SW7 = 1; SW14 = 1;
            INPUT1 = 0; INPUT2 = 0; INPUT3 = 0; INPUT4 = 1;
            pulse_up();
            pulse_up();
            pulse_up();
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Wrap-around increment (3 to 0)", test_num);
            reset_dut();
            SW6 = 1; SW7 = 1; SW14 = 1;
            INPUT1 = 1; INPUT2 = 0; INPUT3 = 0; INPUT4 = 0;
            repeat(4) pulse_up();
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Wrap-around decrement (0 to 3)", test_num);
            reset_dut();
            SW6 = 1; SW7 = 1; SW14 = 1;
            INPUT1 = 0; INPUT2 = 0; INPUT3 = 0; INPUT4 = 1;
            pulse_down();
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: SW14 Qualifier check", test_num);
            reset_dut();
            SW6 = 1; SW7 = 1; SW14 = 0;
            INPUT1 = 1; INPUT2 = 0;
            pulse_up();
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: SW6/SW7 Gatekeeper check", test_num);
            reset_dut();
            SW6 = 0; SW7 = 1; SW14 = 1;
            INPUT1 = 1; INPUT2 = 0;
            pulse_up();
            #1;

            check_outputs(1'b1);
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
        input expected_Z;
        begin
            if (expected_Z === (expected_Z ^ Z ^ expected_Z)) begin
                $display("PASS");
                $display("  Outputs: Z=%b",
                         Z);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Z=%b",
                         expected_Z);
                $display("  Got:      Z=%b",
                         Z);
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
        $dumpvars(0,INPUT1, INPUT2, INPUT3, INPUT4, PB_DOWN, PB_UP, SLOW_CLOCK, SW14, SW6, SW7, Z);
    end

endmodule
