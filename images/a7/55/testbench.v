`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg a;
    reg areset;
    reg b;
    reg c;
    reg clk;
    wire z;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .areset(areset),
        .b(b),
        .c(c),
        .clk(clk),
        .z(z)
    );

    // Clock generation (10ns period)
    initial begin
        areset = 0;
        forever #5 areset = ~areset;
    end

        task reset_dut;

        begin
            @(negedge clk);
            areset = 1;
            a = 0; b = 0; c = 0;
            #5;
            areset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task drive_and_check;

        input va;
        input vb;
        input vc;
        input expected_z;
        begin
            test_num = test_num + 1;
            @(negedge clk);
            a = va;
            b = vb;
            c = vc;
            @(posedge clk);
            #2;
            $display("Test %0d: Inputs {a,b,c} = {%b,%b,%b}", test_num, a, b, c);
            #1;

            check_outputs(expected_z);
        end
        endtask

    task testcase001;

        begin
            reset_dut();
            drive_and_check(0, 0, 0, 0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            drive_and_check(1, 0, 0, 0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            drive_and_check(0, 1, 0, 0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            drive_and_check(0, 0, 1, 0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            drive_and_check(1, 1, 0, 1);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            drive_and_check(1, 0, 1, 1);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            drive_and_check(0, 1, 1, 1);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            drive_and_check(1, 1, 1, 1);
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
        input expected_z;
        begin
            if (expected_z === (expected_z ^ z ^ expected_z)) begin
                $display("PASS");
                $display("  Outputs: z=%b",
                         z);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: z=%b",
                         expected_z);
                $display("  Got:      z=%b",
                         z);
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
        $dumpvars(0,a, areset, b, c, clk, z);
    end

endmodule
