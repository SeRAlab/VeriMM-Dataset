`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg RX;
    wire LED1;
    wire LED2;
    wire LED3;
    wire LED4;
    wire LED5;
    wire TX;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .RX(RX),
        .LED1(LED1),
        .LED2(LED2),
        .LED3(LED3),
        .LED4(LED4),
        .LED5(LED5),
        .TX(TX)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            RX = 0;
            repeat(4) @(posedge CLK);
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Running Testcase %0d: RX=1 (All LEDs ON)", test_num);
            RX = 3'd1;
            @(posedge CLK);
            #2;
            #1;

            check_outputs(1, 1, 1, 1, 1, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Running Testcase %0d: RX=2 (All LEDs OFF)", test_num);
            RX = 3'd2;
            @(posedge CLK);
            #2;
            #1;

            check_outputs(0, 0, 0, 0, 0, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Running Testcase %0d: RX=3 (LEDs 1,2 ON)", test_num);
            RX = 3'd3;
            @(posedge CLK);
            #2;
            #1;

            check_outputs(1, 1, 0, 0, 0, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Running Testcase %0d: RX=4 (LEDs 3,4 ON)", test_num);
            RX = 3'd4;
            @(posedge CLK);
            #2;
            #1;

            check_outputs(0, 0, 1, 1, 0, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Running Testcase %0d: RX=5 (LED 5 ON)", test_num);
            RX = 3'd5;
            @(posedge CLK);
            #2;
            #1;

            check_outputs(0, 0, 0, 0, 1, 0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Running Testcase %0d: State 01 TX output", test_num);
            RX = 3'd1;
            @(posedge CLK);
            #1;
            RX = 3'd1;
            @(posedge CLK);
            #2;

            if (TX === 1'b1) begin
                $display("PASS: TX correctly reflected RX in state 01");
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: TX expected 1, got %b", TX);
                fail_count = fail_count + 1;
            end
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
        input expected_LED1;
        input expected_LED2;
        input expected_LED3;
        input expected_LED4;
        input expected_LED5;
        input expected_TX;
        begin
            if (expected_LED1 === (expected_LED1 ^ LED1 ^ expected_LED1) &&
                expected_LED2 === (expected_LED2 ^ LED2 ^ expected_LED2) &&
                expected_LED3 === (expected_LED3 ^ LED3 ^ expected_LED3) &&
                expected_LED4 === (expected_LED4 ^ LED4 ^ expected_LED4) &&
                expected_LED5 === (expected_LED5 ^ LED5 ^ expected_LED5) &&
                expected_TX === (expected_TX ^ TX ^ expected_TX)) begin
                $display("PASS");
                $display("  Outputs: LED1=%b, LED2=%b, LED3=%b, LED4=%b, LED5=%b, TX=%b",
                         LED1, LED2, LED3, LED4, LED5, TX);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: LED1=%b, LED2=%b, LED3=%b, LED4=%b, LED5=%b, TX=%b",
                         expected_LED1, expected_LED2, expected_LED3, expected_LED4, expected_LED5, expected_TX);
                $display("  Got:      LED1=%b, LED2=%b, LED3=%b, LED4=%b, LED5=%b, TX=%b",
                         LED1, LED2, LED3, LED4, LED5, TX);
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
        $dumpvars(0,CLK, RX, LED1, LED2, LED3, LED4, LED5, TX);
    end

endmodule
