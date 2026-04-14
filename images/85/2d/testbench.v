`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] in1;
    reg [3:0] in2;
    wire [3:0] max_out;
    wire [3:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in1(in1),
        .in2(in2),
        .max_out(max_out),
        .out(out)
    );
    task testcase001;

        begin
            test_num = 1;
            in1 = 4'd2;
            in2 = 4'd3;

            #1;


            check_outputs(4'd5, 4'd5);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            in1 = 4'd7;
            in2 = 4'd8;

            #1;


            check_outputs(4'd15, 4'd15);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            in1 = 4'd10;
            in2 = 4'd10;

            #1;


            check_outputs(4'd4, 4'd4);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            in1 = 4'd0;
            in2 = 4'd0;

            #1;


            check_outputs(4'd0, 4'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            in1 = 4'd15;
            in2 = 4'd1;

            #1;


            check_outputs(4'd0, 4'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            in1 = 4'd15;
            in2 = 4'd15;

            #1;


            check_outputs(4'd14, 4'd14);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            in1 = 4'd8;
            in2 = 4'd0;

            #1;


            check_outputs(4'd8, 4'd8);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            in1 = 4'd12;
            in2 = 4'd5;

            #1;


            check_outputs(4'd1, 4'd1);
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
        input [3:0] expected_max_out;
        input [3:0] expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_max_out === (expected_max_out ^ max_out ^ expected_max_out) &&
                expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: max_out=%h, out=%h",
                         max_out, out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: max_out=%h, out=%h",
                         expected_max_out, expected_out);
                $display("  Got:      max_out=%h, out=%h",
                         max_out, out);
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
