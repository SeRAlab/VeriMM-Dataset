`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] v;
    wire u;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .v(v),
        .u(u)
    );
    task testcase001;

        begin
            v = 4'b0000;
            $display("Test Case 001: v=0000");
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            v = 4'b0001;
            $display("Test Case 002: v=0001");
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            v = 4'b0010;
            $display("Test Case 003: v=0010");
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            v = 4'b0011;
            $display("Test Case 004: v=0011");
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            v = 4'b0100;
            $display("Test Case 005: v=0100");
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            v = 4'b0101;
            $display("Test Case 006: v=0101");
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            v = 4'b0110;
            $display("Test Case 007: v=0110");
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase008;

        begin
            v = 4'b0111;
            $display("Test Case 008: v=0111");
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase009;

        begin
            v = 4'b1000;
            $display("Test Case 009: v=1000");
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase010;

        begin
            v = 4'b1001;
            $display("Test Case 010: v=1001");
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase011;

        begin
            v = 4'b1010;
            $display("Test Case 011: v=1010");
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase012;

        begin
            v = 4'b1011;
            $display("Test Case 012: v=1011");
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase013;

        begin
            v = 4'b1100;
            $display("Test Case 013: v=1100");
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase014;

        begin
            v = 4'b1101;
            $display("Test Case 014: v=1101");
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase015;

        begin
            v = 4'b1110;
            $display("Test Case 015: v=1110");
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase016;

        begin
            v = 4'b1111;
            $display("Test Case 016: v=1111");
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
        testcase009();
        testcase010();
        testcase011();
        testcase012();
        testcase013();
        testcase014();
        testcase015();
        testcase016();
        
        
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
        input expected_u;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_u === (expected_u ^ u ^ expected_u)) begin
                $display("PASS");
                $display("  Outputs: u=%b",
                         u);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: u=%b",
                         expected_u);
                $display("  Got:      u=%b",
                         u);
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
