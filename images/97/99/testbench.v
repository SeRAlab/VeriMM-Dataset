`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] z;
    wire k;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .z(z),
        .k(k)
    );
    task testcase001;

        begin
            z = 4'b0000;
            $display("Test Case 001: z=0000");
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            z = 4'b0001;
            $display("Test Case 002: z=0001");
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            z = 4'b0010;
            $display("Test Case 003: z=0010");
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            z = 4'b0011;
            $display("Test Case 004: z=0011");
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            z = 4'b0100;
            $display("Test Case 005: z=0100");
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            z = 4'b0101;
            $display("Test Case 006: z=0101");
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            z = 4'b0110;
            $display("Test Case 007: z=0110");
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase008;

        begin
            z = 4'b0111;
            $display("Test Case 008: z=0111");
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase009;

        begin
            z = 4'b1000;
            $display("Test Case 009: z=1000");
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase010;

        begin
            z = 4'b1001;
            $display("Test Case 010: z=1001");
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase011;

        begin
            z = 4'b1010;
            $display("Test Case 011: z=1010");
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase012;

        begin
            z = 4'b1011;
            $display("Test Case 012: z=1011");
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase013;

        begin
            z = 4'b1100;
            $display("Test Case 013: z=1100");
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase014;

        begin
            z = 4'b1101;
            $display("Test Case 014: z=1101");
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase015;

        begin
            z = 4'b1110;
            $display("Test Case 015: z=1110");
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase016;

        begin
            z = 4'b1111;
            $display("Test Case 016: z=1111");
            #1;

            check_outputs(1'b1);
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
        input expected_k;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_k === (expected_k ^ k ^ expected_k)) begin
                $display("PASS");
                $display("  Outputs: k=%b",
                         k);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: k=%b",
                         expected_k);
                $display("  Got:      k=%b",
                         k);
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
