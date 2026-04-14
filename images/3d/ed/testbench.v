`timescale 1ns/1ps

module divider_4bit_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    wire [3:0] Q;
    wire [3:0] R;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    divider_4bit dut (
        .A(A),
        .B(B),
        .Q(Q),
        .R(R)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: 0 / 5 (Zero Dividend)", test_num);
            A = 4'd0; B = 4'd5;
            #1;

            check_outputs(4'd0, 4'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: 15 / 1 (Divide by One)", test_num);
            A = 4'd15; B = 4'd1;
            #1;

            check_outputs(4'd15, 4'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: 15 / 15 (Equal values)", test_num);
            A = 4'd15; B = 4'd15;
            #1;

            check_outputs(4'd1, 4'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: 10 / 3 (General division with remainder)", test_num);
            A = 4'd10; B = 4'd3;
            #1;

            check_outputs(4'd3, 4'd1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: 15 / 4 (Max dividend)", test_num);
            A = 4'd15; B = 4'd4;
            #1;

            check_outputs(4'd3, 4'd3);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: 5 / 8 (Dividend < Divisor)", test_num);
            A = 4'd5; B = 4'd8;
            #1;

            check_outputs(4'd0, 4'd5);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: 14 / 2 (Perfect division)", test_num);
            A = 4'd14; B = 4'd2;
            #1;

            check_outputs(4'd7, 4'd0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: 13 / 5", test_num);
            A = 4'd13; B = 4'd5;
            #1;

            check_outputs(4'd2, 4'd3);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: 7 / 2", test_num);
            A = 4'd7; B = 4'd2;
            #1;

            check_outputs(4'd3, 4'd1);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: 8 / 4", test_num);
            A = 4'd8; B = 4'd4;
            #1;

            check_outputs(4'd2, 4'd0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("divider_4bit Testbench");
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
        input [3:0] expected_Q;
        input [3:0] expected_R;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Q === (expected_Q ^ Q ^ expected_Q) &&
                expected_R === (expected_R ^ R ^ expected_R)) begin
                $display("PASS");
                $display("  Outputs: Q=%h, R=%h",
                         Q, R);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%h, R=%h",
                         expected_Q, expected_R);
                $display("  Got:      Q=%h, R=%h",
                         Q, R);
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
