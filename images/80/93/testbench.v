`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [11:0] A;
    reg [11:0] B;
    wire GT;
    wire LT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .GT(GT),
        .LT(LT)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: A=0, B=0 (Equality)", test_num);
            A = 12'd0;
            B = 12'd0;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: A=1, B=0 (A > B)", test_num);
            A = 12'd1;
            B = 12'd0;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: A=0, B=1 (A < B)", test_num);
            A = 12'd0;
            B = 12'd1;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: A=4095, B=4095 (Max Equality)", test_num);
            A = 12'hFFF;
            B = 12'hFFF;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: A=4095, B=0 (Max vs Min GT)", test_num);
            A = 12'hFFF;
            B = 12'h000;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: A=0, B=4095 (Min vs Max LT)", test_num);
            A = 12'h000;
            B = 12'hFFF;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: A=2048, B=2047 (MSB difference GT)", test_num);
            A = 12'd2048;
            B = 12'd2047;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: A=2047, B=2048 (MSB difference LT)", test_num);
            A = 12'd2047;
            B = 12'd2048;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: A=2730, B=2730 (Bit pattern 1010... Equality)", test_num);
            A = 12'hAAA;
            B = 12'hAAA;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: A=1365, B=1364 (Bit pattern 0101... GT by LSB)", test_num);
            A = 12'h555;
            B = 12'h554;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase011;

        begin
            test_num = test_num + 1;
            $display("Test %0d: A=1365, B=1366 (Bit pattern 0101... LT by LSB)", test_num);
            A = 12'h555;
            B = 12'h556;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase012;

        begin
            test_num = test_num + 1;
            $display("Test %0d: A=2048, B=1024 (Mid-range comparison GT)", test_num);
            A = 12'h800;
            B = 12'h400;
            #1;

            check_outputs(1'b1, 1'b0);
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
        input expected_GT;
        input expected_LT;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_GT === (expected_GT ^ GT ^ expected_GT) &&
                expected_LT === (expected_LT ^ LT ^ expected_LT)) begin
                $display("PASS");
                $display("  Outputs: GT=%b, LT=%b",
                         GT, LT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: GT=%b, LT=%b",
                         expected_GT, expected_LT);
                $display("  Got:      GT=%b, LT=%b",
                         GT, LT);
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
