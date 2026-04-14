`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg Ci;
    wire Co;
    wire [3:0] S;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .Ci(Ci),
        .Co(Co),
        .S(S)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            A = 4'd0; B = 4'd0; Ci = 0;
            $display("Test Case %0d: A=%d, B=%d, Ci=%b", test_num, A, B, Ci);
            #1;

            check_outputs(1'b0, 4'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            A = 4'd5; B = 4'd3; Ci = 0;
            $display("Test Case %0d: A=%d, B=%d, Ci=%b", test_num, A, B, Ci);
            #1;

            check_outputs(1'b0, 4'd8);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            A = 4'd2; B = 4'd2; Ci = 1;
            $display("Test Case %0d: A=%d, B=%d, Ci=%b", test_num, A, B, Ci);
            #1;

            check_outputs(1'b0, 4'd5);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            A = 4'd7; B = 4'd8; Ci = 0;
            $display("Test Case %0d: A=%d, B=%d, Ci=%b", test_num, A, B, Ci);
            #1;

            check_outputs(1'b0, 4'd15);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            A = 4'd8; B = 4'd8; Ci = 0;
            $display("Test Case %0d: A=%d, B=%d, Ci=%b", test_num, A, B, Ci);
            #1;

            check_outputs(1'b1, 4'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            A = 4'd15; B = 4'd15; Ci = 1;
            $display("Test Case %0d: A=%d, B=%d, Ci=%b", test_num, A, B, Ci);
            #1;

            check_outputs(1'b1, 4'd15);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            A = 4'd10; B = 4'd5; Ci = 0;
            $display("Test Case %0d: A=%d, B=%d, Ci=%b", test_num, A, B, Ci);
            #1;

            check_outputs(1'b0, 4'd15);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            A = 4'd10; B = 4'd5; Ci = 1;
            $display("Test Case %0d: A=%d, B=%d, Ci=%b", test_num, A, B, Ci);
            #1;

            check_outputs(1'b1, 4'd0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            A = 4'b1010; B = 4'b0101; Ci = 0;
            $display("Test Case %0d: A=%b, B=%b, Ci=%b", test_num, A, B, Ci);
            #1;

            check_outputs(1'b0, 4'b1111);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            A = 4'd12; B = 4'd13; Ci = 1;
            $display("Test Case %0d: A=%d, B=%d, Ci=%b", test_num, A, B, Ci);
            #1;

            check_outputs(1'b1, 4'd10);
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
        input expected_Co;
        input [3:0] expected_S;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Co === (expected_Co ^ Co ^ expected_Co) &&
                expected_S === (expected_S ^ S ^ expected_S)) begin
                $display("PASS");
                $display("  Outputs: Co=%b, S=%h",
                         Co, S);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Co=%b, S=%h",
                         expected_Co, expected_S);
                $display("  Got:      Co=%b, S=%h",
                         Co, S);
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
