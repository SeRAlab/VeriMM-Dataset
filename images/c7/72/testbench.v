`timescale 1ns/1ps

module multiplier_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    wire [7:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    multiplier dut (
        .A(A),
        .B(B),
        .result(result)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Zero multiplication (0 * 0)", test_num);
        A = 4'sb0000;
        B = 4'sb0000;
        #1;

        check_outputs(8'sb00000000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Positive * Positive (3 * 2)", test_num);
        A = 4'sb0011;
        B = 4'sb0010;
        #1;

        check_outputs(8'sb00000110);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Max Positive * Max Positive (7 * 7)", test_num);
        A = 4'sb0111;
        B = 4'sb0111;
        #1;

        check_outputs(8'sb00110001);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Negative * Positive (-1 * 5)", test_num);
        A = 4'sb1111;
        B = 4'sb0101;
        #1;

        check_outputs(8'sb11111011);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Positive * Negative (6 * -2)", test_num);
        A = 4'sb0110;
        B = 4'sb1110;
        #1;

        check_outputs(8'sb11110100);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Negative * Negative (-3 * -4)", test_num);
        A = 4'sb1101;
        B = 4'sb1100;
        #1;

        check_outputs(8'sb00001100);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Min Negative * 1 (-8 * 1)", test_num);
        A = 4'sb1000;
        B = 4'sb0001;
        #1;

        check_outputs(8'sb11111000);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Min Negative * Max Positive (-8 * 7)", test_num);
        A = 4'sb1000;
        B = 4'sb0111;
        #1;

        check_outputs(8'sb11001000);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Min Negative * Min Negative (-8 * -8)", test_num);
        A = 4'sb1000;
        B = 4'sb1000;
        #1;

        check_outputs(8'sb01000000);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Smallest Negative * Smallest Negative (-1 * -1)", test_num);
        A = 4'sb1111;
        B = 4'sb1111;
        #1;

        check_outputs(8'sb00000001);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("multiplier Testbench");
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
        input [7:0] expected_result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: result=%h",
                         result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result=%h",
                         expected_result);
                $display("  Got:      result=%h",
                         result);
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
