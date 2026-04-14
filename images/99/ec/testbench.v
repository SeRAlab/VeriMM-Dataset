`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg in_A1;
    reg in_A2;
    reg in_B1_N;
    wire out_Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in_A1(in_A1),
        .in_A2(in_A2),
        .in_B1_N(in_B1_N),
        .out_Y(out_Y)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Initial Reset", test_num);
            in_B1_N = 1'b1; in_A1 = 1'b0; in_A2 = 1'b0;
            #10;
            in_B1_N = 1'b0;
            #10;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Single Increment (0 -> 1)", test_num);
            in_B1_N = 1'b1; in_A1 = 1'b0; in_A2 = 1'b0; #10;
            in_B1_N = 1'b0; #10;

            in_A1 = 1'b1; in_A2 = 1'b1; #10;
            in_A1 = 1'b0; in_A2 = 1'b0; #10;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Double Increment (0 -> 1 -> 2)", test_num);
            in_B1_N = 1'b1; in_A1 = 1'b0; in_A2 = 1'b0; #10;
            in_B1_N = 1'b0; #10;

            in_A1 = 1'b1; in_A2 = 1'b1; #10;
            in_A1 = 1'b0; in_A2 = 1'b0; #10;

            in_A1 = 1'b1; in_A2 = 1'b1; #10;
            in_A1 = 1'b0; in_A2 = 1'b0; #10;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Increment condition check (in_A1 only)", test_num);
            in_B1_N = 1'b1; in_A1 = 1'b0; in_A2 = 1'b0; #10;
            in_B1_N = 1'b0; #10;
            in_A1 = 1'b1; in_A2 = 1'b0; #10;
            in_A1 = 1'b0; #10;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Increment condition check (in_A2 only)", test_num);
            in_B1_N = 1'b1; in_A1 = 1'b0; in_A2 = 1'b0; #10;
            in_B1_N = 1'b0; #10;
            in_A1 = 1'b0; in_A2 = 1'b1; #10;
            in_A2 = 1'b0; #10;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Reset priority", test_num);
            in_B1_N = 1'b1; in_A1 = 1'b0; in_A2 = 1'b0; #10;
            in_B1_N = 1'b0; #10;

            in_A1 = 1'b1; in_A2 = 1'b1; in_B1_N = 1'b1; #10;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Triple increment (0 -> 1 -> 2 -> 3)", test_num);
            in_B1_N = 1'b1; in_A1 = 1'b0; in_A2 = 1'b0; #10;
            in_B1_N = 1'b0; #10;
            repeat(3) begin
                in_A1 = 1'b1; in_A2 = 1'b1; #10;
                in_A1 = 1'b0; in_A2 = 1'b0; #10;
            end
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Quadruple increment (LSB should be low)", test_num);
            in_B1_N = 1'b1; in_A1 = 1'b0; in_A2 = 1'b0; #10;
            in_B1_N = 1'b0; #10;
            repeat(4) begin
                in_A1 = 1'b1; in_A2 = 1'b1; #10;
                in_A1 = 1'b0; in_A2 = 1'b0; #10;
            end
            #1;

            check_outputs(1'b0);
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
        input expected_out_Y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out_Y === (expected_out_Y ^ out_Y ^ expected_out_Y)) begin
                $display("PASS");
                $display("  Outputs: out_Y=%b",
                         out_Y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_Y=%b",
                         expected_out_Y);
                $display("  Got:      out_Y=%b",
                         out_Y);
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
