`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    wire [3:0] S;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .S(S)
    );
    task testcase001;

        begin
            A = 4'd0;
            B = 4'd0;
            test_num = test_num + 1;
            $display("Test %0d: A=%d, B=%d", test_num, A, B);
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase002;

        begin
            A = 4'd1;
            B = 4'd1;
            test_num = test_num + 1;
            $display("Test %0d: A=%d, B=%d", test_num, A, B);
            #1;

            check_outputs(4'd2);
        end
        endtask

    task testcase003;

        begin
            A = 4'd3;
            B = 4'd4;
            test_num = test_num + 1;
            $display("Test %0d: A=%d, B=%d", test_num, A, B);
            #1;

            check_outputs(4'd7);
        end
        endtask

    task testcase004;

        begin
            A = 4'd7;
            B = 4'd8;
            test_num = test_num + 1;
            $display("Test %0d: A=%d, B=%d", test_num, A, B);
            #1;

            check_outputs(4'd15);
        end
        endtask

    task testcase005;

        begin
            A = 4'd15;
            B = 4'd1;
            test_num = test_num + 1;
            $display("Test %0d: A=%d, B=%d (Checking overflow/carry-out drop)", test_num, A, B);
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase006;

        begin
            A = 4'd10;
            B = 4'd10;
            test_num = test_num + 1;
            $display("Test %0d: A=%d, B=%d (Checking carry propagation)", test_num, A, B);
            #1;

            check_outputs(4'd4);
        end
        endtask

    task testcase007;

        begin
            A = 4'd5;
            B = 4'd10;
            test_num = test_num + 1;
            $display("Test %0d: A=%d, B=%d", test_num, A, B);
            #1;

            check_outputs(4'd15);
        end
        endtask

    task testcase008;

        begin
            A = 4'd15;
            B = 4'd15;
            test_num = test_num + 1;
            $display("Test %0d: A=%d, B=%d", test_num, A, B);
            #1;

            check_outputs(4'd14);
        end
        endtask

    task testcase009;

        begin
            A = 4'b1010;
            B = 4'b0101;
            test_num = test_num + 1;
            $display("Test %0d: A=%b, B=%b", test_num, A, B);
            #1;

            check_outputs(4'b1111);
        end
        endtask

    task testcase010;

        begin
            A = 4'b1100;
            B = 4'b0100;
            test_num = test_num + 1;
            $display("Test %0d: A=%b, B=%b", test_num, A, B);
            #1;

            check_outputs(4'b0000);
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
        input [3:0] expected_S;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_S === (expected_S ^ S ^ expected_S)) begin
                $display("PASS");
                $display("  Outputs: S=%h",
                         S);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: S=%h",
                         expected_S);
                $display("  Got:      S=%h",
                         S);
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
