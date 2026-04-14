`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg OSC_CLK_A;
    reg PB1;
    wire CDONE_A;
    wire LED1;
    wire LED2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .OSC_CLK_A(OSC_CLK_A),
        .PB1(PB1),
        .CDONE_A(CDONE_A),
        .LED1(LED1),
        .LED2(LED2)
    );

    // Clock generation (10ns period)
    initial begin
        OSC_CLK_A = 0;
        forever #5 OSC_CLK_A = ~OSC_CLK_A;
    end

        task reset_dut;

        begin
            PB1 = 0;



            repeat (2) @(posedge OSC_CLK_A);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: PB1 Pressed (High)", test_num);
            reset_dut();
            PB1 = 1'b1;
            #10;

            #1;


            check_outputs(1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: PB1 Released (Low)", test_num);
            reset_dut();
            PB1 = 1'b0;
            #10;

            #1;


            check_outputs(1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Initial Counter Persistence", test_num);
            reset_dut();
            PB1 = 1'b1;

            repeat (1000) @(posedge OSC_CLK_A);
            #1;

            #1;


            check_outputs(1'b0, 1'b0, 1'b0);
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
        input expected_CDONE_A;
        input expected_LED1;
        input expected_LED2;
        begin
            if (expected_CDONE_A === (expected_CDONE_A ^ CDONE_A ^ expected_CDONE_A) &&
                expected_LED1 === (expected_LED1 ^ LED1 ^ expected_LED1) &&
                expected_LED2 === (expected_LED2 ^ LED2 ^ expected_LED2)) begin
                $display("PASS");
                $display("  Outputs: CDONE_A=%b, LED1=%b, LED2=%b",
                         CDONE_A, LED1, LED2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: CDONE_A=%b, LED1=%b, LED2=%b",
                         expected_CDONE_A, expected_LED1, expected_LED2);
                $display("  Got:      CDONE_A=%b, LED1=%b, LED2=%b",
                         CDONE_A, LED1, LED2);
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
        $dumpvars(0,OSC_CLK_A, PB1, CDONE_A, LED1, LED2);
    end

endmodule
