`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg data;
    wire key_pressed;
    wire [7:0] last_pressed;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data(data),
        .key_pressed(key_pressed),
        .last_pressed(last_pressed)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            test_num = test_num + 1;
            data = 1;
            #20;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            $display("Testcase %0d: Sending Scan Code 0x1C", test_num);
            send_ps2_byte(8'h1C);
            #10;
            #1;

            check_outputs(1'b1, 8'h1C);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            $display("Testcase %0d: Sending Scan Code 0x32", test_num);
            send_ps2_byte(8'h32);
            #10;
            #1;

            check_outputs(1'b1, 8'h32);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            $display("Testcase %0d: Sending Scan Code 0x21", test_num);
            send_ps2_byte(8'h21);
            #10;
            #1;

            check_outputs(1'b1, 8'h21);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            $display("Testcase %0d: Sending Break Code Prefix 0xF0", test_num);
            send_ps2_byte(8'hF0);
            #10;
            #1;

            check_outputs(1'b1, 8'hF0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            $display("Testcase %0d: Sending Scan Code 0x45", test_num);
            send_ps2_byte(8'h45);
            #10;
            #1;

            check_outputs(1'b1, 8'h45);
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
        input expected_key_pressed;
        input [7:0] expected_last_pressed;
        begin
            if (expected_key_pressed === (expected_key_pressed ^ key_pressed ^ expected_key_pressed) &&
                expected_last_pressed === (expected_last_pressed ^ last_pressed ^ expected_last_pressed)) begin
                $display("PASS");
                $display("  Outputs: key_pressed=%b, last_pressed=%h",
                         key_pressed, last_pressed);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: key_pressed=%b, last_pressed=%h",
                         expected_key_pressed, expected_last_pressed);
                $display("  Got:      key_pressed=%b, last_pressed=%h",
                         key_pressed, last_pressed);
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
        $dumpvars(0,clk, data, key_pressed, last_pressed);
    end

endmodule
