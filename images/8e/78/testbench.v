`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg btn;
    reg clk;
    reg coin;
    reg reset;
    reg [3:0] stock;
    wire dispense;
    wire [3:0] led;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .btn(btn),
        .clk(clk),
        .coin(coin),
        .reset(reset),
        .stock(stock),
        .dispense(dispense),
        .led(led)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            coin = 0;
            btn = 0;
            stock = 0;
            #20;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Valid coin and button press with available stock");
            test_num = 1;
            reset_dut();
            stock = 4'd10;
            @(posedge clk);


            coin = 1;
            @(posedge clk);
            coin = 0;
            #2;


            btn = 1;
            @(posedge clk);
            btn = 0;
            #2;


            #1;



            check_outputs(1'b1, 4'd10);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Valid coin and button press with NO stock");
            test_num = 2;
            reset_dut();
            stock = 4'd0;
            @(posedge clk);


            coin = 1;
            @(posedge clk);
            coin = 0;
            #2;


            btn = 1;
            @(posedge clk);
            btn = 0;
            #2;


            #1;



            check_outputs(1'b0, 4'd0);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Verify IDLE state LED and dispense");
            test_num = 3;
            reset_dut();
            stock = 4'd5;
            @(posedge clk);
            #2;


            #1;



            check_outputs(1'b0, 4'd5);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Verify return to IDLE after dispense");
            test_num = 4;
            reset_dut();
            stock = 4'd3;
            @(posedge clk);

            coin = 1; @(posedge clk); coin = 0;
            btn = 1; @(posedge clk); btn = 0;

            @(posedge clk);
            @(posedge clk);
            #2;


            #1;



            check_outputs(1'b0, 4'd3);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Coin inserted but no button pressed");
            test_num = 5;
            reset_dut();
            stock = 4'd8;
            @(posedge clk);

            coin = 1;
            @(posedge clk);
            coin = 0;


            repeat(3) @(posedge clk);
            #2;


            #1;



            check_outputs(1'b0, 4'd8);
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
        input expected_dispense;
        input [3:0] expected_led;
        begin
            if (expected_dispense === (expected_dispense ^ dispense ^ expected_dispense) &&
                expected_led === (expected_led ^ led ^ expected_led)) begin
                $display("PASS");
                $display("  Outputs: dispense=%b, led=%h",
                         dispense, led);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dispense=%b, led=%h",
                         expected_dispense, expected_led);
                $display("  Got:      dispense=%b, led=%h",
                         dispense, led);
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
        $dumpvars(0,btn, clk, coin, reset, stock, dispense, led);
    end

endmodule
