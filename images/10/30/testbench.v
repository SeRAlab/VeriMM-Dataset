`timescale 1ns/1ps

module max_heap_comparator_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] a;
    reg [3:0] b;
    wire a_ge_b;
    wire [3:0] max_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    max_heap_comparator dut (
        .a(a),
        .b(b),
        .a_ge_b(a_ge_b),
        .max_out(max_out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: a > b (a=5, b=3)", test_num);
            a = 4'd5;
            b = 4'd3;
            #1;

            check_outputs(1'b1, 4'd5);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: a < b (a=2, b=8)", test_num);
            a = 4'd2;
            b = 4'd8;
            #1;

            check_outputs(1'b0, 4'd8);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: a == b (a=7, b=7)", test_num);
            a = 4'd7;
            b = 4'd7;
            #1;

            check_outputs(1'b1, 4'd7);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Both Zero (a=0, b=0)", test_num);
            a = 4'd0;
            b = 4'd0;
            #1;

            check_outputs(1'b1, 4'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Max vs Min (a=15, b=0)", test_num);
            a = 4'd15;
            b = 4'd0;
            #1;

            check_outputs(1'b1, 4'd15);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Min vs Max (a=0, b=15)", test_num);
            a = 4'd0;
            b = 4'd15;
            #1;

            check_outputs(1'b0, 4'd15);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Both Max (a=15, b=15)", test_num);
            a = 4'd15;
            b = 4'd15;
            #1;

            check_outputs(1'b1, 4'd15);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Close values (a=10, b=11)", test_num);
            a = 4'd10;
            b = 4'd11;
            #1;

            check_outputs(1'b0, 4'd11);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Close values (a=11, b=10)", test_num);
            a = 4'd11;
            b = 4'd10;
            #1;

            check_outputs(1'b1, 4'd11);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Power of 2 (a=8, b=4)", test_num);
            a = 4'd8;
            b = 4'd4;
            #1;

            check_outputs(1'b1, 4'd8);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("max_heap_comparator Testbench");
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
        input expected_a_ge_b;
        input [3:0] expected_max_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_a_ge_b === (expected_a_ge_b ^ a_ge_b ^ expected_a_ge_b) &&
                expected_max_out === (expected_max_out ^ max_out ^ expected_max_out)) begin
                $display("PASS");
                $display("  Outputs: a_ge_b=%b, max_out=%h",
                         a_ge_b, max_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: a_ge_b=%b, max_out=%h",
                         expected_a_ge_b, expected_max_out);
                $display("  Got:      a_ge_b=%b, max_out=%h",
                         a_ge_b, max_out);
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
