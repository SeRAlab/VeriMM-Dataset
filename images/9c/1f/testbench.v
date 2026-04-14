`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg [3:0] C;
    reg [3:0] D;
    wire [3:0] Y0;
    wire [3:0] Y1;
    wire [3:0] Y2;
    wire [3:0] Y3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .C(C),
        .D(D),
        .Y0(Y0),
        .Y1(Y1),
        .Y2(Y2),
        .Y3(Y3)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Input BCD = 0 (0000)", test_num);
            A = 4'd0; B = 4'd0; C = 4'd0; D = 4'd0;

            #1;


            check_outputs(4'd0, 4'd0, 4'd0, 4'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Input BCD = 1 (0001)", test_num);
            A = 4'd0; B = 4'd0; C = 4'd0; D = 4'd1;

            #1;


            check_outputs(4'd0, 4'd0, 4'd0, 4'd1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Input BCD = 5 (0101)", test_num);
            A = 4'd0; B = 4'd1; C = 4'd0; D = 4'd1;

            #1;


            check_outputs(4'd0, 4'd1, 4'd0, 4'd1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Input BCD = 8 (1000)", test_num);
            A = 4'd1; B = 4'd0; C = 4'd0; D = 4'd0;

            #1;


            check_outputs(4'd1, 4'd0, 4'd0, 4'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Input BCD = 9 (1001)", test_num);
            A = 4'd1; B = 4'd0; C = 4'd0; D = 4'd1;

            #1;


            check_outputs(4'd1, 4'd0, 4'd0, 4'd1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Input BCD = 10 (1010) - Invalid BCD", test_num);
            A = 4'd1; B = 4'd0; C = 4'd1; D = 4'd0;


            #1;



            check_outputs(4'd1, 4'd0, 4'd1, 4'd0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Input BCD = 15 (1111) - Invalid BCD", test_num);
            A = 4'd1; B = 4'd1; C = 4'd1; D = 4'd1;
            #1;

            check_outputs(4'd1, 4'd1, 4'd1, 4'd1);
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
        input [3:0] expected_Y0;
        input [3:0] expected_Y1;
        input [3:0] expected_Y2;
        input [3:0] expected_Y3;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Y0 === (expected_Y0 ^ Y0 ^ expected_Y0) &&
                expected_Y1 === (expected_Y1 ^ Y1 ^ expected_Y1) &&
                expected_Y2 === (expected_Y2 ^ Y2 ^ expected_Y2) &&
                expected_Y3 === (expected_Y3 ^ Y3 ^ expected_Y3)) begin
                $display("PASS");
                $display("  Outputs: Y0=%h, Y1=%h, Y2=%h, Y3=%h",
                         Y0, Y1, Y2, Y3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Y0=%h, Y1=%h, Y2=%h, Y3=%h",
                         expected_Y0, expected_Y1, expected_Y2, expected_Y3);
                $display("  Got:      Y0=%h, Y1=%h, Y2=%h, Y3=%h",
                         Y0, Y1, Y2, Y3);
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
