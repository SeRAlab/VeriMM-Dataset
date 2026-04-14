`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] B;
    reg clk;
    wire O0;
    wire O1;
    wire O2;
    wire O3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .B(B),
        .clk(clk),
        .O0(O0),
        .O1(O1),
        .O2(O2),
        .O3(O3)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            B <= 4'b0000;

            repeat (5) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: B = 4'b0001");
            reset_dut();
            @(posedge clk);
            B <= 4'b0001;

            repeat (3) @(posedge clk);
            #1;
            #1;

            check_outputs(1, 0, 0, 0);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: B = 4'b0010");
            reset_dut();
            @(posedge clk);
            B <= 4'b0010;
            repeat (3) @(posedge clk);
            #1;
            #1;

            check_outputs(0, 1, 0, 0);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: B = 4'b0100");
            reset_dut();
            @(posedge clk);
            B <= 4'b0100;
            repeat (3) @(posedge clk);
            #1;
            #1;

            check_outputs(0, 0, 1, 0);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: B = 4'b1000");
            reset_dut();
            @(posedge clk);
            B <= 4'b1000;
            repeat (3) @(posedge clk);
            #1;
            #1;

            check_outputs(0, 0, 0, 1);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: B = 4'b0000");
            reset_dut();
            @(posedge clk);
            B <= 4'b0000;
            repeat (3) @(posedge clk);
            #1;
            #1;

            check_outputs(0, 0, 0, 0);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: B = 4'b1001 (Value > 1000)");
            reset_dut();
            @(posedge clk);
            B <= 4'b1001;
            repeat (3) @(posedge clk);
            #1;
            #1;

            check_outputs(0, 0, 0, 0);
        end
        endtask

    task testcase007;

        begin
            $display("Running testcase007: B = 4'b0011 (Non-matching state)");
            reset_dut();
            @(posedge clk);
            B <= 4'b0011;
            repeat (3) @(posedge clk);
            #1;
            #1;

            check_outputs(0, 0, 0, 0);
        end
        endtask

    task testcase008;

        begin
            $display("Running testcase008: B = 4'b1111 (Max value)");
            reset_dut();
            @(posedge clk);
            B <= 4'b1111;
            repeat (3) @(posedge clk);
            #1;
            #1;

            check_outputs(0, 0, 0, 0);
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
        input expected_O0;
        input expected_O1;
        input expected_O2;
        input expected_O3;
        begin
            if (expected_O0 === (expected_O0 ^ O0 ^ expected_O0) &&
                expected_O1 === (expected_O1 ^ O1 ^ expected_O1) &&
                expected_O2 === (expected_O2 ^ O2 ^ expected_O2) &&
                expected_O3 === (expected_O3 ^ O3 ^ expected_O3)) begin
                $display("PASS");
                $display("  Outputs: O0=%b, O1=%b, O2=%b, O3=%b",
                         O0, O1, O2, O3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: O0=%b, O1=%b, O2=%b, O3=%b",
                         expected_O0, expected_O1, expected_O2, expected_O3);
                $display("  Got:      O0=%b, O1=%b, O2=%b, O3=%b",
                         O0, O1, O2, O3);
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
        $dumpvars(0,B, clk, O0, O1, O2, O3);
    end

endmodule
