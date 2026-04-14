`timescale 1ns/1ps

module Comparator8bit_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] a;
    reg [7:0] b;
    wire eq;
    wire gt;
    wire lt;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    Comparator8bit dut (
        .a(a),
        .b(b),
        .eq(eq),
        .gt(gt),
        .lt(lt)
    );
    task testcase001;

        begin
            test_num = 1;
            a = 8'd0;
            b = 8'd0;
            $display("Testcase %0d: a=%0d, b=%0d", test_num, a, b);
            #1;

            check_outputs(1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            a = 8'd255;
            b = 8'd255;
            $display("Testcase %0d: a=%0d, b=%0d", test_num, a, b);
            #1;

            check_outputs(1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            a = 8'd128;
            b = 8'd128;
            $display("Testcase %0d: a=%0d, b=%0d", test_num, a, b);
            #1;

            check_outputs(1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            a = 8'd1;
            b = 8'd0;
            $display("Testcase %0d: a=%0d, b=%0d", test_num, a, b);
            #1;

            check_outputs(1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            a = 8'd255;
            b = 8'd0;
            $display("Testcase %0d: a=%0d, b=%0d", test_num, a, b);
            #1;

            check_outputs(1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            a = 8'd150;
            b = 8'd100;
            $display("Testcase %0d: a=%0d, b=%0d", test_num, a, b);
            #1;

            check_outputs(1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            a = 8'd0;
            b = 8'd1;
            $display("Testcase %0d: a=%0d, b=%0d", test_num, a, b);
            #1;

            check_outputs(1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            a = 8'd0;
            b = 8'd255;
            $display("Testcase %0d: a=%0d, b=%0d", test_num, a, b);
            #1;

            check_outputs(1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            a = 8'd42;
            b = 8'd84;
            $display("Testcase %0d: a=%0d, b=%0d", test_num, a, b);
            #1;

            check_outputs(1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            a = 8'hAA;
            b = 8'h55;
            $display("Testcase %0d: a=%0h, b=%0h", test_num, a, b);
            #1;

            check_outputs(1'b0, 1'b1, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("Comparator8bit Testbench");
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
            #1; // Small delay for combinational logic to settle
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

endmodule
