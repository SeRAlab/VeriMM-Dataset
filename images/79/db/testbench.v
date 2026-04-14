`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    wire led0;
    wire led1;
    wire led2;
    wire led3;
    wire led4;
    wire led5;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .led0(led0),
        .led1(led1),
        .led2(led2),
        .led3(led3),
        .led4(led4),
        .led5(led5)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            force dut.counter = 26'd0;
            @(posedge clk);
            #1;
            release dut.counter;
            $display("DUT Counter reset to 0");
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase %0d: Testing Pattern 0 (000)", test_num);
            #20;
            #1;

            check_outputs(1,0,0,0,0,0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase %0d: Testing Pattern 1 (001)", test_num);
            force dut.counter = 26'd8388608;
            #20;
            #1;

            check_outputs(0,1,0,0,0,0);
            release dut.counter;
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase %0d: Testing Pattern 2 (010)", test_num);
            force dut.counter = 26'd16777216;
            #20;
            #1;

            check_outputs(0,0,1,0,0,0);
            release dut.counter;
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase %0d: Testing Pattern 3 (011)", test_num);
            force dut.counter = 26'd25165824;
            #20;
            #1;

            check_outputs(0,0,0,1,0,0);
            release dut.counter;
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase %0d: Testing Pattern 4 (100)", test_num);
            force dut.counter = 26'd33554432;
            #20;
            #1;

            check_outputs(0,0,0,0,1,0);
            release dut.counter;
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("Testcase %0d: Testing Pattern 5 (101)", test_num);
            force dut.counter = 26'd41943040;
            #20;
            #1;

            check_outputs(0,0,0,0,0,1);
            release dut.counter;
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;
            $display("Testcase %0d: Testing Pattern 6 (110)", test_num);
            force dut.counter = 26'd50331648;
            #20;
            #1;

            check_outputs(1,1,1,1,1,1);
            release dut.counter;
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            test_num = 8;
            $display("Testcase %0d: Testing Pattern 7 (111)", test_num);
            force dut.counter = 26'd58720256;
            #20;
            #1;

            check_outputs(0,0,0,0,0,0);
            release dut.counter;
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
        testcase008();
        
        
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
        input expected_led0;
        input expected_led1;
        input expected_led2;
        input expected_led3;
        input expected_led4;
        input expected_led5;
        begin
            if (expected_led0 === (expected_led0 ^ led0 ^ expected_led0) &&
                expected_led1 === (expected_led1 ^ led1 ^ expected_led1) &&
                expected_led2 === (expected_led2 ^ led2 ^ expected_led2) &&
                expected_led3 === (expected_led3 ^ led3 ^ expected_led3) &&
                expected_led4 === (expected_led4 ^ led4 ^ expected_led4) &&
                expected_led5 === (expected_led5 ^ led5 ^ expected_led5)) begin
                $display("PASS");
                $display("  Outputs: led0=%b, led1=%b, led2=%b, led3=%b, led4=%b, led5=%b",
                         led0, led1, led2, led3, led4, led5);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: led0=%b, led1=%b, led2=%b, led3=%b, led4=%b, led5=%b",
                         expected_led0, expected_led1, expected_led2, expected_led3, expected_led4, expected_led5);
                $display("  Got:      led0=%b, led1=%b, led2=%b, led3=%b, led4=%b, led5=%b",
                         led0, led1, led2, led3, led4, led5);
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
        $dumpvars(0,clk, led0, led1, led2, led3, led4, led5);
    end

endmodule
