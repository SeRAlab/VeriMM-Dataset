`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] A;
    reg [2:0] B;
    reg [2:0] C;
    wire [2:0] max;
    wire [2:0] mid;
    wire [2:0] min;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .C(C),
        .max(max),
        .mid(mid),
        .min(min)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: A=7, B=4, C=1 (Descending)", test_num);
            A = 3'd7; B = 3'd4; C = 3'd1;
            #1;

            check_outputs(3'd7, 3'd4, 3'd1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: A=4, B=7, C=1", test_num);
            A = 3'd4; B = 3'd7; C = 3'd1;
            #1;

            check_outputs(3'd7, 3'd4, 3'd1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: A=1, B=4, C=7 (Ascending)", test_num);
            A = 3'd1; B = 3'd4; C = 3'd7;
            #1;

            check_outputs(3'd7, 3'd4, 3'd1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: A=5, B=5, C=2", test_num);
            A = 3'd5; B = 3'd5; C = 3'd2;
            #1;

            check_outputs(3'd5, 3'd5, 3'd2);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: A=1, B=6, C=1", test_num);
            A = 3'd1; B = 3'd6; C = 3'd1;
            #1;

            check_outputs(3'd6, 3'd1, 3'd1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: A=3, B=3, C=3", test_num);
            A = 3'd3; B = 3'd3; C = 3'd3;
            #1;

            check_outputs(3'd3, 3'd3, 3'd3);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: A=0, B=0, C=0", test_num);
            A = 3'd0; B = 3'd0; C = 3'd0;
            #1;

            check_outputs(3'd0, 3'd0, 3'd0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: A=7, B=7, C=7", test_num);
            A = 3'd7; B = 3'd7; C = 3'd7;
            #1;

            check_outputs(3'd7, 3'd7, 3'd7);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: A=0, B=7, C=3", test_num);
            A = 3'd0; B = 3'd7; C = 3'd3;
            #1;

            check_outputs(3'd7, 3'd3, 3'd0);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: A=2, B=1, C=5", test_num);
            A = 3'd2; B = 3'd1; C = 3'd5;
            #1;

            check_outputs(3'd5, 3'd2, 3'd1);
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
        input [2:0] expected_max;
        input [2:0] expected_mid;
        input [2:0] expected_min;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_max === (expected_max ^ max ^ expected_max) &&
                expected_mid === (expected_mid ^ mid ^ expected_mid) &&
                expected_min === (expected_min ^ min ^ expected_min)) begin
                $display("PASS");
                $display("  Outputs: max=%h, mid=%h, min=%h",
                         max, mid, min);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: max=%h, mid=%h, min=%h",
                         expected_max, expected_mid, expected_min);
                $display("  Got:      max=%h, mid=%h, min=%h",
                         max, mid, min);
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
