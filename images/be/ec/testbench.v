`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg BUTTON;
    reg CLOCK_50;
    reg [1:0] COIN;
    reg RESET;
    wire CANDY_DISPENSE;
    wire [1:0] CHANGE_DISPENSE;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .BUTTON(BUTTON),
        .CLOCK_50(CLOCK_50),
        .COIN(COIN),
        .RESET(RESET),
        .CANDY_DISPENSE(CANDY_DISPENSE),
        .CHANGE_DISPENSE(CHANGE_DISPENSE)
    );

    // Clock generation (10ns period)
    initial begin
        CLOCK_50 = 0;
        forever #5 CLOCK_50 = ~CLOCK_50;
    end

        task reset_dut;

        begin
            RESET = 1;
            BUTTON = 0;
            COIN = 2'b00;
            repeat(2) @(posedge CLOCK_50);
            RESET = 0;
            @(posedge CLOCK_50);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            repeat(2) @(posedge CLOCK_50);
            #1;

            check_outputs(1'b0, 2'b00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();

            COIN = 2'b10; @(posedge CLOCK_50);
            COIN = 2'b00; @(posedge CLOCK_50);

            COIN = 2'b01; @(posedge CLOCK_50);
            COIN = 2'b00; @(posedge CLOCK_50);

            BUTTON = 1; @(posedge CLOCK_50);
            BUTTON = 0;
            repeat(2) @(posedge CLOCK_50);
            #1;

            check_outputs(1'b1, 2'b00);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();

            COIN = 2'b11; @(posedge CLOCK_50);
            COIN = 2'b00; @(posedge CLOCK_50);

            BUTTON = 1; @(posedge CLOCK_50);
            BUTTON = 0;
            repeat(2) @(posedge CLOCK_50);
            #1;

            check_outputs(1'b1, 2'b10);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            repeat(3) begin
                COIN = 2'b01; @(posedge CLOCK_50);
                COIN = 2'b00; @(posedge CLOCK_50);
            end
            BUTTON = 1; @(posedge CLOCK_50);
            BUTTON = 0;
            repeat(2) @(posedge CLOCK_50);
            #1;

            check_outputs(1'b1, 2'b00);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            COIN = 2'b10; @(posedge CLOCK_50);
            COIN = 2'b00; @(posedge CLOCK_50);
            BUTTON = 1; @(posedge CLOCK_50);
            BUTTON = 0;
            repeat(2) @(posedge CLOCK_50);
            #1;

            check_outputs(1'b0, 2'b00);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            COIN = 2'b10; @(posedge CLOCK_50);
            COIN = 2'b00; @(posedge CLOCK_50);
            COIN = 2'b10; @(posedge CLOCK_50);
            COIN = 2'b00; @(posedge CLOCK_50);
            BUTTON = 1; @(posedge CLOCK_50);
            BUTTON = 0;
            repeat(2) @(posedge CLOCK_50);
            #1;

            check_outputs(1'b1, 2'b01);
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
        input expected_CANDY_DISPENSE;
        input [1:0] expected_CHANGE_DISPENSE;
        begin
            if (expected_CANDY_DISPENSE === (expected_CANDY_DISPENSE ^ CANDY_DISPENSE ^ expected_CANDY_DISPENSE) &&
                expected_CHANGE_DISPENSE === (expected_CHANGE_DISPENSE ^ CHANGE_DISPENSE ^ expected_CHANGE_DISPENSE)) begin
                $display("PASS");
                $display("  Outputs: CANDY_DISPENSE=%b, CHANGE_DISPENSE=%h",
                         CANDY_DISPENSE, CHANGE_DISPENSE);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: CANDY_DISPENSE=%b, CHANGE_DISPENSE=%h",
                         expected_CANDY_DISPENSE, expected_CHANGE_DISPENSE);
                $display("  Got:      CANDY_DISPENSE=%b, CHANGE_DISPENSE=%h",
                         CANDY_DISPENSE, CHANGE_DISPENSE);
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
        $dumpvars(0,BUTTON, CLOCK_50, COIN, RESET, CANDY_DISPENSE, CHANGE_DISPENSE);
    end

endmodule
