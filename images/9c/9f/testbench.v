`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLOCK_ENABLE;
    reg D_OUT_0;
    reg D_OUT_1;
    reg INPUT_CLK;
    reg LATCH_INPUT_VALUE;
    reg OUTPUT_CLK;
    reg OUTPUT_ENABLE;
    reg PACKAGE_PIN;
    wire D_IN_0;
    wire D_IN_1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLOCK_ENABLE(CLOCK_ENABLE),
        .D_OUT_0(D_OUT_0),
        .D_OUT_1(D_OUT_1),
        .INPUT_CLK(INPUT_CLK),
        .LATCH_INPUT_VALUE(LATCH_INPUT_VALUE),
        .OUTPUT_CLK(OUTPUT_CLK),
        .OUTPUT_ENABLE(OUTPUT_ENABLE),
        .PACKAGE_PIN(PACKAGE_PIN),
        .D_IN_0(D_IN_0),
        .D_IN_1(D_IN_1)
    );

    // Clock generation (10ns period)
    initial begin
        INPUT_CLK = 0;
        forever #5 INPUT_CLK = ~INPUT_CLK;
    end

        task reset_dut;

        begin
            CLOCK_ENABLE = 0;
            D_OUT_0 = 0;
            D_OUT_1 = 0;
            LATCH_INPUT_VALUE = 0;
            OUTPUT_ENABLE = 0;
            PACKAGE_PIN = 0;
            @(posedge INPUT_CLK);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test Case %0d: Steady High Input", test_num);

            CLOCK_ENABLE = 1;
            PACKAGE_PIN = 1;


            @(posedge INPUT_CLK);
            @(negedge INPUT_CLK);
            #2;

            #1;


            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test Case %0d: DDR Input (High on Rise, Low on Fall)", test_num);

            CLOCK_ENABLE = 1;


            @(negedge INPUT_CLK);
            PACKAGE_PIN = 1;


            @(posedge INPUT_CLK);
            #2 PACKAGE_PIN = 0;


            @(negedge INPUT_CLK);
            #2;

            #1;


            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test Case %0d: Clock Enable Disabled", test_num);


            CLOCK_ENABLE = 1;
            PACKAGE_PIN = 0;
            @(posedge INPUT_CLK);
            @(negedge INPUT_CLK);


            CLOCK_ENABLE = 0;
            PACKAGE_PIN = 1;
            @(posedge INPUT_CLK);
            @(negedge INPUT_CLK);
            #2;


            #1;



            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test Case %0d: DDR Input (Low on Rise, High on Fall)", test_num);

            CLOCK_ENABLE = 1;


            @(negedge INPUT_CLK);
            PACKAGE_PIN = 0;


            @(posedge INPUT_CLK);
            #2 PACKAGE_PIN = 1;


            @(negedge INPUT_CLK);
            #2;

            #1;


            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test Case %0d: Latch Input Control", test_num);

            CLOCK_ENABLE = 1;
            PACKAGE_PIN = 1;
            @(posedge INPUT_CLK);
            @(negedge INPUT_CLK);

            LATCH_INPUT_VALUE = 1;
            #2 PACKAGE_PIN = 0;
            @(posedge INPUT_CLK);
            @(negedge INPUT_CLK);
            #2;


            #1;



            check_outputs(1'b1, 1'b1);
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
        input expected_D_IN_0;
        input expected_D_IN_1;
        begin
            if (expected_D_IN_0 === (expected_D_IN_0 ^ D_IN_0 ^ expected_D_IN_0) &&
                expected_D_IN_1 === (expected_D_IN_1 ^ D_IN_1 ^ expected_D_IN_1)) begin
                $display("PASS");
                $display("  Outputs: D_IN_0=%b, D_IN_1=%b",
                         D_IN_0, D_IN_1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: D_IN_0=%b, D_IN_1=%b",
                         expected_D_IN_0, expected_D_IN_1);
                $display("  Got:      D_IN_0=%b, D_IN_1=%b",
                         D_IN_0, D_IN_1);
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
        $dumpvars(0,CLOCK_ENABLE, D_OUT_0, D_OUT_1, INPUT_CLK, LATCH_INPUT_VALUE, OUTPUT_CLK, OUTPUT_ENABLE, PACKAGE_PIN, D_IN_0, D_IN_1);
    end

endmodule
