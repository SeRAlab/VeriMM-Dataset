`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg clr;
    reg en;
    reg rst_n;
    wire C;
    wire [7:0] counter;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .clr(clr),
        .en(en),
        .rst_n(rst_n),
        .C(C),
        .counter(counter)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            en = 0;
            clr = 0;
            @(negedge clk);
            rst_n = 1;
            @(negedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Basic Reset", test_num);
            reset_dut();
            #1;

            check_outputs(0, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Count to 10", test_num);
            reset_dut();
            en = 1;
            repeat(10) @(negedge clk);
            en = 0;
            #1;

            check_outputs(0, 8'd10);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Clear signal high", test_num);
            reset_dut();
            en = 1;
            repeat(5) @(negedge clk);
            clr = 1;
            @(negedge clk);
            clr = 0;
            #1;

            check_outputs(0, 8'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Enable/Disable behavior", test_num);
            reset_dut();
            en = 1;
            repeat(5) @(negedge clk);
            en = 0;
            repeat(5) @(negedge clk);
            #1;

            check_outputs(0, 8'd5);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Carry output at 0xFF", test_num);
            reset_dut();
            en = 1;

            repeat(255) @(negedge clk);
            #1;

            check_outputs(1, 8'hFF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Wrap around to 0x00", test_num);
            reset_dut();
            en = 1;
            repeat(256) @(negedge clk);
            #1;

            check_outputs(0, 8'h00);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Clear priority over Enable", test_num);
            reset_dut();
            en = 1;
            clr = 1;
            repeat(10) @(negedge clk);
            #1;

            check_outputs(0, 8'h00);
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
        input expected_C;
        input [7:0] expected_counter;
        begin
            if (expected_C === (expected_C ^ C ^ expected_C) &&
                expected_counter === (expected_counter ^ counter ^ expected_counter)) begin
                $display("PASS");
                $display("  Outputs: C=%b, counter=%h",
                         C, counter);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: C=%b, counter=%h",
                         expected_C, expected_counter);
                $display("  Got:      C=%b, counter=%h",
                         C, counter);
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
        $dumpvars(0,clk, clr, en, rst_n, C, counter);
    end

endmodule
