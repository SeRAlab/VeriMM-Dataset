`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [2:0] a;
    reg [2:0] b;
    reg clk;
    wire eq;
    wire gt;
    wire lt;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .clk(clk),
        .eq(eq),
        .gt(gt),
        .lt(lt)
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
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: a=0, b=0 (Equal)", test_num);
            reset_dut();
            a = 3'b000;
            b = 3'b000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1, 0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: a=7, b=7 (Equal)", test_num);
            reset_dut();
            a = 3'b111;
            b = 3'b111;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1, 0, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: a=5, b=2 (Greater)", test_num);
            reset_dut();
            a = 3'b101;
            b = 3'b010;
            @(posedge clk);
            #1;
            #1;

            check_outputs(0, 1, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: a=1, b=6 (Less)", test_num);
            reset_dut();
            a = 3'b001;
            b = 3'b110;
            @(posedge clk);
            #1;
            #1;

            check_outputs(0, 0, 1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: a=7, b=0 (Greater)", test_num);
            reset_dut();
            a = 3'b111;
            b = 3'b000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(0, 1, 0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: a=0, b=7 (Less)", test_num);
            reset_dut();
            a = 3'b000;
            b = 3'b111;
            @(posedge clk);
            #1;
            #1;

            check_outputs(0, 0, 1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: a=4, b=3 (Greater)", test_num);
            reset_dut();
            a = 3'b100;
            b = 3'b011;
            @(posedge clk);
            #1;
            #1;

            check_outputs(0, 1, 0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: a=3, b=4 (Less)", test_num);
            reset_dut();
            a = 3'b011;
            b = 3'b100;
            @(posedge clk);
            #1;
            #1;

            check_outputs(0, 0, 1);
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
        input expected_eq;
        input expected_gt;
        input expected_lt;
        begin
            if (expected_eq === (expected_eq ^ eq ^ expected_eq) &&
                expected_gt === (expected_gt ^ gt ^ expected_gt) &&
                expected_lt === (expected_lt ^ lt ^ expected_lt)) begin
                $display("PASS");
                $display("  Outputs: eq=%b, gt=%b, lt=%b",
                         eq, gt, lt);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: eq=%b, gt=%b, lt=%b",
                         expected_eq, expected_gt, expected_lt);
                $display("  Got:      eq=%b, gt=%b, lt=%b",
                         eq, gt, lt);
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
        $dumpvars(0,a, b, clk, eq, gt, lt);
    end

endmodule
