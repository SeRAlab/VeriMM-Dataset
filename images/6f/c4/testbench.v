`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] dipswitch;
    reg key0;
    reg key1;
    wire [7:0] led;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .dipswitch(dipswitch),
        .key0(key0),
        .key1(key1),
        .led(led)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            dipswitch = 4'b0000;
            key0 = 1'b0;
            key1 = 1'b0;
            @(posedge clk);
            #1;
            $display("DUT Reset performed.");
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: All inputs low", test_num);
            reset_dut();

            dipswitch = 4'b0000;
            key0 = 0;
            key1 = 0;

            repeat(2) @(posedge clk);
            #1;

            #1;


            check_outputs(8'b00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Testing dipswitches (Pattern 1010)", test_num);
            reset_dut();

            dipswitch = 4'b1010;
            key0 = 0;
            key1 = 0;

            repeat(2) @(posedge clk);
            #1;

            #1;


            check_outputs(8'b00001010);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Testing Key 0", test_num);
            reset_dut();

            dipswitch = 4'b0000;
            key0 = 1;
            key1 = 0;

            repeat(2) @(posedge clk);
            #1;

            #1;


            check_outputs(8'b00010000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Testing Key 1", test_num);
            reset_dut();

            dipswitch = 4'b0000;
            key0 = 0;
            key1 = 1;

            repeat(2) @(posedge clk);
            #1;

            #1;


            check_outputs(8'b00100000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Combined inputs (Keys and Switches)", test_num);
            reset_dut();

            dipswitch = 4'b1111;
            key0 = 1;
            key1 = 1;

            repeat(2) @(posedge clk);
            #1;

            #1;


            check_outputs(8'b00111111);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %0d: Alternating switches", test_num);
            reset_dut();

            dipswitch = 4'b0101;
            key0 = 0;
            key1 = 1;

            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(8'b00100101);
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
        input [7:0] expected_led;
        begin
            if (expected_led === (expected_led ^ led ^ expected_led)) begin
                $display("PASS");
                $display("  Outputs: led=%h",
                         led);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: led=%h",
                         expected_led);
                $display("  Got:      led=%h",
                         led);
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
        $dumpvars(0,clk, dipswitch, key0, key1, led);
    end

endmodule
