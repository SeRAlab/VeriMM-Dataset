`timescale 1ns/1ps

module dot_product_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A0;
    reg [3:0] A1;
    reg [3:0] A2;
    reg [3:0] A3;
    reg [3:0] A4;
    reg [3:0] B0;
    reg [3:0] B1;
    reg [3:0] B2;
    reg [3:0] B3;
    reg [3:0] B4;
    wire [9:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dot_product dut (
        .A0(A0),
        .A1(A1),
        .A2(A2),
        .A3(A3),
        .A4(A4),
        .B0(B0),
        .B1(B1),
        .B2(B2),
        .B3(B3),
        .B4(B4),
        .result(result)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: All Zeros", test_num);
        A0 = 4'd0; A1 = 4'd0; A2 = 4'd0; A3 = 4'd0; A4 = 4'd0;
        B0 = 4'd0; B1 = 4'd0; B2 = 4'd0; B3 = 4'd0; B4 = 4'd0;
        #1;

        check_outputs(10'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Unity Vectors", test_num);
        A0 = 4'd1; A1 = 4'd1; A2 = 4'd1; A3 = 4'd1; A4 = 4'd1;
        B0 = 4'd1; B1 = 4'd1; B2 = 4'd1; B3 = 4'd1; B4 = 4'd1;
        #1;

        check_outputs(10'd5);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Single Component Max", test_num);
        A0 = 4'd15; A1 = 4'd0;  A2 = 4'd0;  A3 = 4'd0;  A4 = 4'd0;
        B0 = 4'd15; B1 = 4'd0;  B2 = 4'd0;  B3 = 4'd0;  B4 = 4'd0;
        #1;

        check_outputs(10'd225);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Orthogonal Vectors", test_num);
        A0 = 4'd5;  A1 = 4'd0;  A2 = 4'd10; A3 = 4'd0;  A4 = 4'd15;
        B0 = 4'd0;  B1 = 4'd5;  B2 = 4'd0;  B3 = 4'd10; B4 = 4'd0;
        #1;

        check_outputs(10'd0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Mixed Values", test_num);
        A0 = 4'd1;  A1 = 4'd2;  A2 = 4'd3;  A3 = 4'd4;  A4 = 4'd5;
        B0 = 4'd5;  B1 = 4'd4;  B2 = 4'd3;  B3 = 4'd2;  B4 = 4'd1;

        #1;


        check_outputs(10'd35);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Power of Two Components", test_num);
        A0 = 4'd1;  A1 = 4'd2;  A2 = 4'd4;  A3 = 4'd8;  A4 = 4'd1;
        B0 = 4'd1;  B1 = 4'd1;  B2 = 4'd1;  B3 = 4'd1;  B4 = 4'd1;

        #1;


        check_outputs(10'd16);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Near Maximum (10-bit limit check)", test_num);
        A0 = 4'd15; A1 = 4'd15; A2 = 4'd15; A3 = 4'd15; A4 = 4'd0;
        B0 = 4'd15; B1 = 4'd15; B2 = 4'd15; B3 = 4'd15; B4 = 4'd0;

        #1;


        check_outputs(10'd900);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Absolute Maximum (Truncation handling)", test_num);
        A0 = 4'd15; A1 = 4'd15; A2 = 4'd15; A3 = 4'd15; A4 = 4'd15;
        B0 = 4'd15; B1 = 4'd15; B2 = 4'd15; B3 = 4'd15; B4 = 4'd15;

        #1;


        check_outputs(10'd101);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("dot_product Testbench");
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
        input [9:0] expected_result;
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
