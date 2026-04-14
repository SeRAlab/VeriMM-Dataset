`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg bclk;
    reg in_data;
    reg lrclk;
    reg reset_n;
    wire [15:0] data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .bclk(bclk),
        .in_data(in_data),
        .lrclk(lrclk),
        .reset_n(reset_n),
        .data(data)
    );

    // Clock generation (10ns period)
    initial begin
        bclk = 0;
        forever #5 bclk = ~bclk;
    end

        task reset_dut;

        begin
            reset_n = 0;
            lrclk = 0;
            in_data = 0;
            #20;
            reset_n = 1;
            #20;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shifting 0xAAAA", test_num);
            reset_dut();
            shift_in_data(16'hAAAA);
            #1;

            check_outputs(16'hAAAA);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shifting 0x5555", test_num);
            reset_dut();
            shift_in_data(16'h5555);
            #1;

            check_outputs(16'h5555);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shifting 0xFFFF", test_num);
            reset_dut();
            shift_in_data(16'hFFFF);
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shifting 0x0000", test_num);
            reset_dut();
            shift_in_data(16'h0000);
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shifting 0x1234", test_num);
            reset_dut();
            shift_in_data(16'h1234);
            #1;

            check_outputs(16'h1234);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shifting 0xBEEF", test_num);
            reset_dut();
            shift_in_data(16'hBEEF);
            #1;

            check_outputs(16'hBEEF);
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
        input [15:0] expected_data;
        begin
            if (expected_data === (expected_data ^ data ^ expected_data)) begin
                $display("PASS");
                $display("  Outputs: data=%h",
                         data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data=%h",
                         expected_data);
                $display("  Got:      data=%h",
                         data);
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
        $dumpvars(0,bclk, in_data, lrclk, reset_n, data);
    end

endmodule
