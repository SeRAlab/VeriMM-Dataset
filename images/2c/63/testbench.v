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
            A = 4'd12; B = 4'd0;
            $display("Testcase %0d: Division by Zero (A=12, B=0)", test_num);
            #1;

            check_outputs(4'd0, 4'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            A = 4'd0; B = 4'd5;
            $display("Testcase %0d: Dividend is Zero (A=0, B=5)", test_num);
            #1;

            check_outputs(4'd0, 4'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            A = 4'd3; B = 4'd8;
            $display("Testcase %0d: A < B (A=3, B=8)", test_num);
            #1;

            check_outputs(4'd0, 4'd3);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            A = 4'd9; B = 4'd9;
            $display("Testcase %0d: A equals B (A=9, B=9)", test_num);
            #1;

            check_outputs(4'd1, 4'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            A = 4'd13; B = 4'd1;
            $display("Testcase %0d: Divide by 1 (A=13, B=1)", test_num, A, B);
            #1;

            check_outputs(4'd13, 4'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            A = 4'd11; B = 4'd3;
            $display("Testcase %0d: Standard Division (A=11, B=3)", test_num);
            #1;

            check_outputs(4'd3, 4'd2);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            A = 4'd15; B = 4'd2;
            $display("Testcase %0d: Max Dividend (A=15, B=2)", test_num);
            #1;

            check_outputs(4'd7, 4'd1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            A = 4'd15; B = 4'd15;
            $display("Testcase %0d: Max Values (A=15, B=15)", test_num);
            #1;

            check_outputs(4'd1, 4'd0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            A = 4'd1; B = 4'd1;
            $display("Testcase %0d: Smallest Non-Zero (A=1, B=1)", test_num);
            #1;

            check_outputs(4'd1, 4'd0);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            A = 4'd14; B = 4'd4;
            $display("Testcase %0d: Standard Division (A=14, B=4)", test_num);
            #1;

            check_outputs(4'd3, 4'd2);
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
