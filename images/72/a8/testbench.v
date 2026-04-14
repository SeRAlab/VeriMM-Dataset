`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    wire LED1;
    wire LED2;
    wire LED3;
    wire LED4;
    wire P1A10;
    wire P1A7;
    wire P1A8;
    wire P1A9;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .LED1(LED1),
        .LED2(LED2),
        .LED3(LED3),
        .LED4(LED4),
        .P1A10(P1A10),
        .P1A7(P1A7),
        .P1A8(P1A8),
        .P1A9(P1A9)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin

            force dut.count = 24'b0;
            #10;
            release dut.count;
            @(posedge CLK);
        end
        endtask
    task set_counter;

        input [23:0] value;
        begin
            force dut.count = value;
            #1;
            release dut.count;
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            $display("\nTest Case %0d: Verifying initial state (Counter=0, MSB=0)", test_num);
            reset_dut();

            #1;


            check_outputs(1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTest Case %0d: Verifying transition to MSB=1 (Blink ON)", test_num);
            reset_dut();

            set_counter(24'h7FFFFF);
            @(posedge CLK);
            #1;

            #1;


            check_outputs(1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTest Case %0d: Verifying wrap-around to MSB=0 (Blink OFF)", test_num);
            reset_dut();

            set_counter(24'hFFFFFF);
            @(posedge CLK);
            #1;

            #1;


            check_outputs(1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTest Case %0d: Verifying output remains stable during counting", test_num);
            reset_dut();
            set_counter(24'h800000);
            repeat(100) @(posedge CLK);
            #1;

            #1;


            check_outputs(1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1);
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
        input expected_P1A10;
        input expected_P1A7;
        input expected_P1A8;
        input expected_P1A9;
        begin
            if (expected_LED1 === (expected_LED1 ^ LED1 ^ expected_LED1) &&
                expected_LED2 === (expected_LED2 ^ LED2 ^ expected_LED2) &&
                expected_LED3 === (expected_LED3 ^ LED3 ^ expected_LED3) &&
                expected_LED4 === (expected_LED4 ^ LED4 ^ expected_LED4) &&
                expected_P1A10 === (expected_P1A10 ^ P1A10 ^ expected_P1A10) &&
                expected_P1A7 === (expected_P1A7 ^ P1A7 ^ expected_P1A7) &&
                expected_P1A8 === (expected_P1A8 ^ P1A8 ^ expected_P1A8) &&
                expected_P1A9 === (expected_P1A9 ^ P1A9 ^ expected_P1A9)) begin
                $display("PASS");
                $display("  Outputs: LED1=%b, LED2=%b, LED3=%b, LED4=%b, P1A10=%b, P1A7=%b, P1A8=%b, P1A9=%b",
                         LED1, LED2, LED3, LED4, P1A10, P1A7, P1A8, P1A9);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: LED1=%b, LED2=%b, LED3=%b, LED4=%b, P1A10=%b, P1A7=%b, P1A8=%b, P1A9=%b",
                         expected_LED1, expected_LED2, expected_LED3, expected_LED4, expected_P1A10, expected_P1A7, expected_P1A8, expected_P1A9);
                $display("  Got:      LED1=%b, LED2=%b, LED3=%b, LED4=%b, P1A10=%b, P1A7=%b, P1A8=%b, P1A9=%b",
                         LED1, LED2, LED3, LED4, P1A10, P1A7, P1A8, P1A9);
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
        $dumpvars(0,CLK, LED1, LED2, LED3, LED4, P1A10, P1A7, P1A8, P1A9);
    end

endmodule
