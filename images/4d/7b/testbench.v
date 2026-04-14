`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] a;
    reg i;
    wire A0;
    wire A1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .i(i),
        .A0(A0),
        .A1(A1)
    );
    task testcase001;

        begin
            $display("Testcase 001: State J (001), Input i=0 -> Next state L (100)");
            a = 3'b001;
            i = 1'b0;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: State J (001), Input i=1 -> Next state K (010)");
            a = 3'b001;
            i = 1'b1;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: State K (010), Input i=0 -> Next state J (001)");
            a = 3'b010;
            i = 1'b0;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: State K (010), Input i=1 -> Next state L (100)");
            a = 3'b010;
            i = 1'b1;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: State L (100), Input i=0 -> Next state J (001)");
            a = 3'b100;
            i = 1'b0;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: State L (100), Input i=1 -> Next state K (010)");
            a = 3'b100;
            i = 1'b1;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Invalid State (000), Input i=0");
            a = 3'b000;
            i = 1'b0;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: Invalid State (111), Input i=1");
            a = 3'b111;
            i = 1'b1;



            #1;




            check_outputs(1'b0, 1'b1);
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
        input expected_A0;
        input expected_A1;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_A0 === (expected_A0 ^ A0 ^ expected_A0) &&
                expected_A1 === (expected_A1 ^ A1 ^ expected_A1)) begin
                $display("PASS");
                $display("  Outputs: A0=%b, A1=%b",
                         A0, A1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: A0=%b, A1=%b",
                         expected_A0, expected_A1);
                $display("  Got:      A0=%b, A1=%b",
                         A0, A1);
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
