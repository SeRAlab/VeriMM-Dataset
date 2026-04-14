`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLOCK;
    reg RESET;
    reg X;
    wire [1:0] CurrentState;
    wire Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLOCK(CLOCK),
        .RESET(RESET),
        .X(X),
        .CurrentState(CurrentState),
        .Y(Y)
    );

    // Clock generation (10ns period)
    initial begin
        CLOCK = 0;
        forever #5 CLOCK = ~CLOCK;
    end

        task reset_dut;

        begin
            RESET = 0;
            X = 0;
            @(posedge CLOCK);
            #2 RESET = 1;
            @(posedge CLOCK);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            #1;


            check_outputs(2'b00, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            X = 1;
            @(posedge CLOCK);
            #2;

            #1;


            check_outputs(2'b01, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            X = 1;
            @(posedge CLOCK);
            @(posedge CLOCK);
            #2;

            #1;


            check_outputs(2'b10, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            X = 1;
            @(posedge CLOCK);
            @(posedge CLOCK);
            @(posedge CLOCK);
            #2;

            #1;


            check_outputs(2'b11, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            X = 1;
            @(posedge CLOCK);
            @(posedge CLOCK);
            @(posedge CLOCK);
            @(posedge CLOCK);
            #2;

            #1;


            check_outputs(2'b00, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            X = 1;
            @(posedge CLOCK);
            @(posedge CLOCK);
            #2;
            RESET = 0;
            #2;

            #1;


            check_outputs(2'b00, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            X = 1;
            @(posedge CLOCK);
            X = 0;
            @(posedge CLOCK);
            #2;
            #1;

            check_outputs(2'b01, 1'b0);
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
        input [1:0] expected_CurrentState;
        input expected_Y;
        begin
            if (expected_CurrentState === (expected_CurrentState ^ CurrentState ^ expected_CurrentState) &&
                expected_Y === (expected_Y ^ Y ^ expected_Y)) begin
                $display("PASS");
                $display("  Outputs: CurrentState=%h, Y=%b",
                         CurrentState, Y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: CurrentState=%h, Y=%b",
                         expected_CurrentState, expected_Y);
                $display("  Got:      CurrentState=%h, Y=%b",
                         CurrentState, Y);
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
        $dumpvars(0,CLOCK, RESET, X, CurrentState, Y);
    end

endmodule
