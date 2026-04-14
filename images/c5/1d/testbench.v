`timescale 1ns/1ps

module add_sub_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg C;
    wire [3:0] D;
    wire [3:0] S;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    add_sub dut (
        .A(A),
        .B(B),
        .C(C),
        .D(D),
        .S(S)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            A = 4'd5;
            B = 4'd3;
            C = 1'b0;
            $display("Testcase %0d: Basic Addition (5 + 3)", test_num);

            #1;


            check_outputs(4'd2, 4'd8);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            A = 4'd10;
            B = 4'd4;
            C = 1'b1;
            $display("Testcase %0d: Basic Subtraction (10 - 4)", test_num);

            #1;


            check_outputs(4'd6, 4'd14);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            A = 4'd12;
            B = 4'd7;
            C = 1'b0;
            $display("Testcase %0d: Addition with Overflow (12 + 7 = 19 -> 3)", test_num);

            #1;


            check_outputs(4'd5, 4'd3);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            A = 4'd3;
            B = 4'd8;
            C = 1'b1;
            $display("Testcase %0d: Subtraction with Underflow (3 - 8 = -5 -> 11)", test_num);

            #1;


            check_outputs(4'd11, 4'd11);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            A = 4'd0;
            B = 4'd0;
            C = 1'b0;
            $display("Testcase %0d: Zero Inputs Addition", test_num);
            #1;

            check_outputs(4'd0, 4'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            A = 4'd15;
            B = 4'd15;
            C = 1'b1;
            $display("Testcase %0d: Max Inputs Subtraction (15 - 15)", test_num);
            #1;

            check_outputs(4'd0, 4'd14);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            A = 4'd15;
            B = 4'd1;
            C = 1'b0;
            $display("Testcase %0d: Addition at boundary (15 + 1)", test_num);
            #1;

            check_outputs(4'd14, 4'd0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            A = 4'd8;
            B = 4'd8;
            C = 1'b0;
            $display("Testcase %0d: Power of 2 Addition (8 + 8)", test_num);
            #1;

            check_outputs(4'd0, 4'd0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("add_sub Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        
        
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
        input [3:0] expected_D;
        input [3:0] expected_S;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_D === (expected_D ^ D ^ expected_D) &&
                expected_S === (expected_S ^ S ^ expected_S)) begin
                $display("PASS");
                $display("  Outputs: D=%h, S=%h",
                         D, S);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: D=%h, S=%h",
                         expected_D, expected_S);
                $display("  Got:      D=%h, S=%h",
                         D, S);
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
