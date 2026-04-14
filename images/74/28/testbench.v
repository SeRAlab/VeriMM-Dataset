`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg x0;
    reg y0;
    reg z0;
    wire x3;
    wire y3;
    wire z3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .x0(x0),
        .y0(y0),
        .z0(z0),
        .x3(x3),
        .y3(y3),
        .z3(z3)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            x0 = 0;
            y0 = 0;
            z0 = 0;

            repeat (5) @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %03d: Continuous High Input", test_num);

            x0 = 1; y0 = 1; z0 = 1;
            repeat (3) @(posedge clk);

            #2;
            #1;

            check_outputs(1, 1, 1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %03d: Single Pulse Timing", test_num);


            x0 = 1; y0 = 1; z0 = 1;
            @(posedge clk);
            #1;

            x0 = 0; y0 = 0; z0 = 0;
            @(posedge clk);
            #1;

            x0 = 0; y0 = 0; z0 = 0;
            @(posedge clk);

            #2;


            #1;



            check_outputs(1, 0, 0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %03d: Late Arrival Pulse", test_num);


            x0 = 0; y0 = 0; z0 = 0;
            @(posedge clk); #1;

            x0 = 0; y0 = 0; z0 = 0;
            @(posedge clk); #1;

            x0 = 1; y0 = 1; z0 = 1;
            @(posedge clk);

            #2;


            #1;



            check_outputs(0, 1, 1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %03d: Alternating Pattern 101", test_num);


            x0 = 1; y0 = 1; z0 = 1;
            @(posedge clk); #1;

            x0 = 0; y0 = 0; z0 = 0;
            @(posedge clk); #1;

            x0 = 1; y0 = 1; z0 = 1;
            @(posedge clk);

            #2;

            #1;


            check_outputs(1, 1, 1);
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
        input expected_x3;
        input expected_y3;
        input expected_z3;
        begin
            if (expected_x3 === (expected_x3 ^ x3 ^ expected_x3) &&
                expected_y3 === (expected_y3 ^ y3 ^ expected_y3) &&
                expected_z3 === (expected_z3 ^ z3 ^ expected_z3)) begin
                $display("PASS");
                $display("  Outputs: x3=%b, y3=%b, z3=%b",
                         x3, y3, z3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: x3=%b, y3=%b, z3=%b",
                         expected_x3, expected_y3, expected_z3);
                $display("  Got:      x3=%b, y3=%b, z3=%b",
                         x3, y3, z3);
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
        $dumpvars(0,clk, x0, y0, z0, x3, y3, z3);
    end

endmodule
