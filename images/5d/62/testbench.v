`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg button1;
    reg button2;
    reg clk;
    reg coin;
    wire dispense1;
    wire dispense2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .button1(button1),
        .button2(button2),
        .clk(clk),
        .coin(coin),
        .dispense1(dispense1),
        .dispense2(dispense2)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            button1 = 0;
            button2 = 0;
            coin = 0;
            repeat(2) @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            coin = 1; @(posedge clk); #1;
            coin = 0;

            button1 = 1; @(posedge clk); #1;
            #1;

            check_outputs(1, 0);
            button1 = 0;
            @(posedge clk);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();

            coin = 1; @(posedge clk); #1;
            coin = 0;

            button2 = 1; @(posedge clk); #1;
            #1;

            check_outputs(0, 1);
            button2 = 0;
            @(posedge clk);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();

            button1 = 1; @(posedge clk); #1;
            #1;

            check_outputs(0, 0);
            button1 = 0;
            @(posedge clk);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();

            coin = 1; @(posedge clk); #1;
            coin = 0;

            @(posedge clk); #1;
            #1;

            check_outputs(0, 0);

            button1 = 1; @(posedge clk); #1;
            #1;

            check_outputs(0, 0);
            button1 = 0;
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();

            coin = 1; @(posedge clk); #1;
            coin = 0; button1 = 1; @(posedge clk); #1;
            button1 = 0; @(posedge clk); #1;

            coin = 1; @(posedge clk); #1;
            coin = 0; button1 = 1; @(posedge clk); #1;
            #1;

            check_outputs(1, 0);
            button1 = 0;
            @(posedge clk);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();

            for (i = 0; i < 9; i = i + 1) begin
                coin = 1; @(posedge clk); #1;
                coin = 0; button2 = 1; @(posedge clk); #1;
                button2 = 0; @(posedge clk); #1;
            end

            coin = 1; @(posedge clk); #1;
            coin = 0; button2 = 1; @(posedge clk); #1;
            #1;

            check_outputs(0, 0);
            button2 = 0;
            @(posedge clk);
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
        input expected_dispense1;
        input expected_dispense2;
        begin
            if (expected_dispense1 === (expected_dispense1 ^ dispense1 ^ expected_dispense1) &&
                expected_dispense2 === (expected_dispense2 ^ dispense2 ^ expected_dispense2)) begin
                $display("PASS");
                $display("  Outputs: dispense1=%b, dispense2=%b",
                         dispense1, dispense2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dispense1=%b, dispense2=%b",
                         expected_dispense1, expected_dispense2);
                $display("  Got:      dispense1=%b, dispense2=%b",
                         dispense1, dispense2);
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
        $dumpvars(0,button1, button2, clk, coin, dispense1, dispense2);
    end

endmodule
