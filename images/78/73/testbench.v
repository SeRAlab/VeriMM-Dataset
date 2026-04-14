`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK_IN;
    reg RST_N;
    wire [2:0] RGB_LED;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK_IN(CLK_IN),
        .RST_N(RST_N),
        .RGB_LED(RGB_LED)
    );

    // Clock generation (10ns period)
    initial begin
        CLK_IN = 0;
        forever #5 CLK_IN = ~CLK_IN;
    end

        task reset_dut;

        begin
            RST_N = 0;
            #20;
            RST_N = 1;
            #20;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verifying LED is OFF during active-low reset", test_num);
            RST_N = 0;
            #100;

            #1;


            check_outputs(3'b000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verifying LED enters White (3'b111) after reset release", test_num);
            reset_dut();

            repeat(5) @(posedge CLK_IN);
            #1;
            #1;

            check_outputs(3'b111);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verifying LED remains White (3'b111) and doesn't toggle prematurely", test_num);
            reset_dut();

            repeat(1000) @(posedge CLK_IN);
            #1;
            #1;

            check_outputs(3'b111);
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
        input [2:0] expected_RGB_LED;
        begin
            if (expected_RGB_LED === (expected_RGB_LED ^ RGB_LED ^ expected_RGB_LED)) begin
                $display("PASS");
                $display("  Outputs: RGB_LED=%h",
                         RGB_LED);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: RGB_LED=%h",
                         expected_RGB_LED);
                $display("  Got:      RGB_LED=%h",
                         RGB_LED);
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
        $dumpvars(0,CLK_IN, RST_N, RGB_LED);
    end

endmodule
