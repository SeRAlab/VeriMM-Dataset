`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg in1;
    reg in2;
    reg [1:0] vin1;
    reg [3:0] vin2;
    reg [1:0] vin3;
    reg [3:0] vin4;
    wire out;
    wire vout;
    wire vout1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in1(in1),
        .in2(in2),
        .vin1(vin1),
        .vin2(vin2),
        .vin3(vin3),
        .vin4(vin4),
        .out(out),
        .vout(vout),
        .vout1(vout1)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase 001: All zeros");
            in1 = 0; in2 = 0;
            vin1 = 2'b00; vin2 = 4'b0000;
            vin3 = 2'b00; vin4 = 4'b0000;
            #1;

            check_outputs(0, 0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase 002: Logical AND (out) - Partial");
            in1 = 1; in2 = 0;
            vin1 = 0; vin2 = 0;
            vin3 = 0; vin4 = 0;
            #1;

            check_outputs(0, 0, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase 003: Logical AND (out) - Success");
            in1 = 1; in2 = 1;
            vin1 = 0; vin2 = 0;
            vin3 = 0; vin4 = 0;
            #1;

            check_outputs(1, 0, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase 004: Logical AND (vout) - Both non-zero");
            in1 = 0; in2 = 0;
            vin1 = 2'b10; vin2 = 4'b0001;
            vin3 = 0; vin4 = 0;
            #1;

            check_outputs(0, 1, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase 005: Logical AND (vout) - One zero");
            in1 = 0; in2 = 0;
            vin1 = 2'b11; vin2 = 4'b0000;
            vin3 = 0; vin4 = 0;
            #1;

            check_outputs(0, 0, 0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase 006: Logical OR (vout1) - vin3 non-zero");
            in1 = 0; in2 = 0;
            vin1 = 0; vin2 = 0;
            vin3 = 2'b01; vin4 = 4'b0000;
            #1;

            check_outputs(0, 0, 1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase 007: Logical OR (vout1) - vin4 non-zero");
            in1 = 0; in2 = 0;
            vin1 = 0; vin2 = 0;
            vin3 = 2'b00; vin4 = 4'b1010;
            #1;

            check_outputs(0, 0, 1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase 008: Logical OR (vout1) - Both zero");
            in1 = 0; in2 = 0;
            vin1 = 0; vin2 = 0;
            vin3 = 2'b00; vin4 = 4'b0000;
            #1;

            check_outputs(0, 0, 0);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Testcase 009: Maximum values / All True");
            in1 = 1; in2 = 1;
            vin1 = 2'b11; vin2 = 4'b1111;
            vin3 = 2'b11; vin4 = 4'b1111;
            #1;

            check_outputs(1, 1, 1);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Testcase 010: Boundary bit check");
            in1 = 1; in2 = 1;
            vin1 = 2'b01; vin2 = 4'b1000;
            vin3 = 2'b10; vin4 = 4'b0001;
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
        input expected_out;
        input expected_vout;
        input expected_vout1;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out) &&
                expected_vout === (expected_vout ^ vout ^ expected_vout) &&
                expected_vout1 === (expected_vout1 ^ vout1 ^ expected_vout1)) begin
                $display("PASS");
                $display("  Outputs: out=%b, vout=%b, vout1=%b",
                         out, vout, vout1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%b, vout=%b, vout1=%b",
                         expected_out, expected_vout, expected_vout1);
                $display("  Got:      out=%b, vout=%b, vout1=%b",
                         out, vout, vout1);
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
