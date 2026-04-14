`timescale 1ns/1ps

module mul_4bit_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    wire [7:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mul_4bit dut (
        .A(A),
        .B(B),
        .result(result)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Zero Multiplier", test_num);
        A = 4'd0;
        B = 4'd10;
        #1;

        check_outputs(8'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Zero Multiplicand", test_num);
        A = 4'd7;
        B = 4'd0;
        #1;

        check_outputs(8'd0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Identity Case (B=1)", test_num);
        A = 4'd13;
        B = 4'd1;
        #1;

        check_outputs(8'd13);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Identity Case (A=1)", test_num);
        A = 4'd1;
        B = 4'd9;
        #1;

        check_outputs(8'd9);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Maximum Values (15 * 15)", test_num);
        A = 4'd15;
        B = 4'd15;
        #1;

        check_outputs(8'd225);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Power of Two (4 * 8)", test_num);
        A = 4'd4;
        B = 4'd8;
        #1;

        check_outputs(8'd32);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Prime Multiplication (7 * 11)", test_num);
        A = 4'd7;
        B = 4'd11;
        #1;

        check_outputs(8'd77);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Typical Case (12 * 5)", test_num);
        A = 4'd12;
        B = 4'd5;
        #1;

        check_outputs(8'd60);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Typical Case (3 * 14)", test_num);
        A = 4'd3;
        B = 4'd14;
        #1;

        check_outputs(8'd42);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Symmetric Test (A=10, B=10)", test_num);
        A = 4'd10;
        B = 4'd10;
        #1;

        check_outputs(8'd100);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("mul_4bit Testbench");
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
