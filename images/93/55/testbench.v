`timescale 1ns/1ps

module another_new_module_tb;

    // Testbench signals (sequential circuit)
    reg a;
    reg clock;
    wire b;
    wire y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    another_new_module dut (
        .a(a),
        .clock(clock),
        .b(b),
        .y(y)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            a = 0;
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase %0d: Checking outputs at T=20ns", test_num);

            a = 0; #4;
            a = 1; #10;
            a = 1; #5;
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase %0d: Checking outputs at T=30ns", test_num);

            a = 0; #4;
            a = 1; #10;
            a = 1; #10;
            a = 1; #5;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase %0d: Checking outputs at T=40ns", test_num);

            a = 0; #4;
            a = 1; #5;
            a = 0; #5;
            a = 1; #5;
            a = 0; #5;
            a = 1; #5;
            a = 1; #5;
            a = 1; #5;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase %0d: Checking outputs at T=50ns", test_num);

            a = 0; #4;
            a = 1; #10;
            a = 1; #10;
            a = 1; #10;
            a = 1; #10;
            a = 1; #5;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("another_new_module Testbench");
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
        input expected_b;
        input expected_y;
        begin
            if (expected_b === (expected_b ^ b ^ expected_b) &&
                expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: b=%b, y=%b",
                         b, y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: b=%b, y=%b",
                         expected_b, expected_y);
                $display("  Got:      b=%b, y=%b",
                         b, y);
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
        $dumpvars(0,a, clock, b, y);
    end

endmodule
