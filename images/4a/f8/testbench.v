`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] A;
    reg [3:0] B;
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
        .A(A),
        .B(B),
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
            A <= 4'd0;
            B <= 4'd0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Zero comparison (0 == 0)", test_num);
            A <= 4'sd0;
            B <= 4'sd0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1, 0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Positive comparison (5 > 2)", test_num);
            A <= 4'sd5;
            B <= 4'sd2;
            @(posedge clk);
            #2;
            #1;

            check_outputs(0, 1, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Positive comparison (2 < 5)", test_num);
            A <= 4'sd2;
            B <= 4'sd5;
            @(posedge clk);
            #2;
            #1;

            check_outputs(0, 0, 1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Negative equality (-4 == -4)", test_num);
            A <= -4'sd4;
            B <= -4'sd4;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1, 0, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Negative comparison (-1 > -8)", test_num);
            A <= -4'sd1;
            B <= -4'sd8;
            @(posedge clk);
            #2;
            #1;

            check_outputs(0, 1, 0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Negative comparison (-8 < -1)", test_num);
            A <= -4'sd8;
            B <= -4'sd1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(0, 0, 1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Mixed sign (7 > -8)", test_num);
            A <= 4'sd7;
            B <= -4'sd8;
            @(posedge clk);
            #2;
            #1;

            check_outputs(0, 1, 0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Mixed sign (-8 < 7)", test_num);
            A <= -4'sd8;
            B <= 4'sd7;
            @(posedge clk);
            #2;
            #1;

            check_outputs(0, 0, 1);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Testcase %0d: Zero and Negative (0 > -1)", test_num);
            A <= 4'sd0;
            B <= -4'sd1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(0, 1, 0);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Testcase %0d: Boundary Positive (7 == 7)", test_num);
            A <= 4'sd7;
            B <= 4'sd7;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1, 0, 0);
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
        testcase009();
        testcase010();
        
        
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
        $dumpvars(0,A, B, clk, eq, gt, lt);
    end

endmodule
