`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg a;
    reg b;
    reg clk;
    wire [1:0] y;
    wire [1:0] z;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .clk(clk),
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
            b = 1;
            @(posedge clk);
            #1;
            a = 0;
            b = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Input A activation", test_num);
            reset_dut();
            a = 1;
            b = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(2'b10, 2'b01);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Input B activation", test_num);
            reset_dut();
            a = 0;
            b = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'b00, 2'b10);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Transition A to B", test_num);
            reset_dut();

            a = 1; b = 0;
            @(posedge clk);
            #1;

            a = 0; b = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'b00, 2'b10);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Transition B to A", test_num);
            reset_dut();

            a = 0; b = 1;
            @(posedge clk);
            #1;

            a = 1; b = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'b10, 2'b01);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Idle inputs (a=0, b=0)", test_num);
            reset_dut();

            a = 0; b = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(2'b00, 2'b10);
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
        input [1:0] expected_y;
        input [1:0] expected_z;
        begin
            if (expected_y === (expected_y ^ y ^ expected_y) &&
                expected_z === (expected_z ^ z ^ expected_z)) begin
                $display("PASS");
                $display("  Outputs: y=%h, z=%h",
                         y, z);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: y=%h, z=%h",
                         expected_y, expected_z);
                $display("  Got:      y=%h, z=%h",
                         y, z);
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
        $dumpvars(0,a, b, clk, y, z);
    end

endmodule
