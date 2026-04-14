`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg A;
    reg B;
    wire R;
    wire Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .R(R),
        .Y(Y)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            A = 8'd10;
            B = 8'd3;
            #1;

            check_outputs(8'd3, 8'd1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            A = 8'd20;
            B = 8'd5;
            #1;

            check_outputs(8'd4, 8'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            A = 8'd5;
            B = 8'd12;
            #1;

            check_outputs(8'd0, 8'd5);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            A = 8'd0;
            B = 8'd7;
            #1;

            check_outputs(8'd0, 8'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            A = 8'd45;
            B = 8'd1;
            #1;

            check_outputs(8'd45, 8'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            A = 8'd64;
            B = 8'd8;
            #1;

            check_outputs(8'd8, 8'd0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            A = 8'd255;
            B = 8'd2;
            #1;

            check_outputs(8'd127, 8'd1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            A = 8'd255;
            B = 8'd255;
            #1;

            check_outputs(8'd1, 8'd0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            A = 8'd17;
            B = 8'd5;
            #1;

            check_outputs(8'd3, 8'd2);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            A = 8'd200;
            B = 8'd13;
            #1;

            check_outputs(8'd15, 8'd5);
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
        input expected_R;
        input expected_Y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_R === (expected_R ^ R ^ expected_R) &&
                expected_Y === (expected_Y ^ Y ^ expected_Y)) begin
                $display("PASS");
                $display("  Outputs: R=%b, Y=%b",
                         R, Y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: R=%b, Y=%b",
                         expected_R, expected_Y);
                $display("  Got:      R=%b, Y=%b",
                         R, Y);
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
