`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg CLKIN;
    reg [3:0] J1i;
    wire [3:0] J1o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLKIN(CLKIN),
        .J1i(J1i),
        .J1o(J1o)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case 001: J1i = 4'h0");
            J1i = 4'h0;
            CLKIN = 0;
            #5 CLKIN = 1;
            #5 CLKIN = 0;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case 002: J1i = 4'hF");
            J1i = 4'hF;
            CLKIN = 0;
            #5 CLKIN = 1;
            #5 CLKIN = 0;
            #1;

            check_outputs(4'hF);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case 003: J1i = 4'hA");
            J1i = 4'hA;
            CLKIN = 0;
            #5 CLKIN = 1;
            #5 CLKIN = 0;
            #1;

            check_outputs(4'hA);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case 004: J1i = 4'h5");
            J1i = 4'h5;
            CLKIN = 0;
            #5 CLKIN = 1;
            #5 CLKIN = 0;
            #1;

            check_outputs(4'h5);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case 005: J1i = 4'h1");
            J1i = 4'h1;
            CLKIN = 0;
            #5 CLKIN = 1;
            #5 CLKIN = 0;
            #1;

            check_outputs(4'h1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case 006: J1i = 4'h2");
            J1i = 4'h2;
            CLKIN = 0;
            #5 CLKIN = 1;
            #5 CLKIN = 0;
            #1;

            check_outputs(4'h2);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case 007: J1i = 4'h4");
            J1i = 4'h4;
            CLKIN = 0;
            #5 CLKIN = 1;
            #5 CLKIN = 0;
            #1;

            check_outputs(4'h4);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test Case 008: J1i = 4'h8");
            J1i = 4'h8;
            CLKIN = 0;
            #5 CLKIN = 1;
            #5 CLKIN = 0;
            #1;

            check_outputs(4'h8);
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
        input [3:0] expected_J1o;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_J1o === (expected_J1o ^ J1o ^ expected_J1o)) begin
                $display("PASS");
                $display("  Outputs: J1o=%h",
                         J1o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: J1o=%h",
                         expected_J1o);
                $display("  Got:      J1o=%h",
                         J1o);
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
