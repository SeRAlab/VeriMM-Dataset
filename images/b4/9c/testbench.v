`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg a;
    reg b;
    reg c;
    reg clk;
    wire w;
    wire x;
    wire y;
    wire z;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .c(c),
        .clk(clk),
        .w(w),
        .x(x),
        .y(y),
        .z(z)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            a = 0;
            b = 0;
            c = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            a = 0; b = 0; c = 0;
            @(posedge clk);
            #2;
            $display("Test %0d: All inputs 0", test_num);
            #1;

            check_outputs(0, 0, 0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            a = 1; b = 1; c = 1;
            @(posedge clk);
            #2;
            $display("Test %0d: All inputs 1", test_num);
            #1;

            check_outputs(1, 1, 1, 1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            a = 1; b = 0; c = 1;
            @(posedge clk);
            #2;
            $display("Test %0d: a=1, b=0, c=1 (Checking mapping)", test_num);
            #1;

            check_outputs(1, 0, 0, 1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            a = 0; b = 1; c = 0;
            @(posedge clk);
            #2;
            $display("Test %0d: a=0, b=1, c=0 (Checking redundancy)", test_num);
            #1;

            check_outputs(0, 1, 1, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();

            a = 1; b = 1; c = 1;
            @(posedge clk);
            #2;

            a = 0; b = 0; c = 0;
            #5;
            $display("Test %0d: Data stability between clock edges", test_num);

            #1;


            check_outputs(1, 1, 1, 1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();

            a = 1; b = 0; c = 0;
            @(posedge clk);
            #2;

            a = 0; b = 1; c = 1;
            @(posedge clk);
            #2;
            $display("Test %0d: Sequential update check", test_num);
            #1;

            check_outputs(0, 1, 1, 1);
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
        input expected_w;
        input expected_x;
        input expected_y;
        input expected_z;
        begin
            if (expected_w === (expected_w ^ w ^ expected_w) &&
                expected_x === (expected_x ^ x ^ expected_x) &&
                expected_y === (expected_y ^ y ^ expected_y) &&
                expected_z === (expected_z ^ z ^ expected_z)) begin
                $display("PASS");
                $display("  Outputs: w=%b, x=%b, y=%b, z=%b",
                         w, x, y, z);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: w=%b, x=%b, y=%b, z=%b",
                         expected_w, expected_x, expected_y, expected_z);
                $display("  Got:      w=%b, x=%b, y=%b, z=%b",
                         w, x, y, z);
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
        $dumpvars(0,a, b, c, clk, w, x, y, z);
    end

endmodule
