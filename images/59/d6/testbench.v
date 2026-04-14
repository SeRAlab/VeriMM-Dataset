`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg S;
    wire [3:0] C;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .S(S),
        .C(C)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        A = 4'd3; B = 4'd4; S = 1'b0;
        $display("Test %0d: Addition (S=0) -> 3 + 4", test_num);
        #1;

        check_outputs(4'd7);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        A = 4'd8; B = 4'd8; S = 1'b0;
        $display("Test %0d: Addition (S=0) -> 8 + 8 (Wrap to 0)", test_num);
        #1;

        check_outputs(4'd0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        A = 4'd10; B = 4'd5; S = 1'b0;
        $display("Test %0d: Addition (S=0) -> 10 + 5", test_num);
        #1;

        check_outputs(4'd15);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        A = 4'd12; B = 4'd0; S = 1'b0;
        $display("Test %0d: Addition (S=0) -> 12 + 0", test_num);
        #1;

        check_outputs(4'd12);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        A = 4'd10; B = 4'd3; S = 1'b1;
        $display("Test %0d: Subtraction (S=1) -> 10 - 3", test_num);
        #1;

        check_outputs(4'd7);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        A = 4'd7; B = 4'd7; S = 1'b1;
        $display("Test %0d: Subtraction (S=1) -> 7 - 7", test_num);
        #1;

        check_outputs(4'd0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        A = 4'd2; B = 4'd5; S = 1'b1;
        $display("Test %0d: Subtraction (S=1) -> 2 - 5 (Underflow wrap)", test_num);

        #1;


        check_outputs(4'd13);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        A = 4'd15; B = 4'd0; S = 1'b1;
        $display("Test %0d: Subtraction (S=1) -> 15 - 0", test_num);
        #1;

        check_outputs(4'd15);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        A = 4'd0; B = 4'd1; S = 1'b1;
        $display("Test %0d: Subtraction (S=1) -> 0 - 1 (Underflow wrap)", test_num);
        #1;

        check_outputs(4'd15);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        A = 4'd15; B = 4'd1; S = 1'b0;
        $display("Test %0d: Addition (S=0) -> 15 + 1 (Overflow wrap)", test_num);
        #1;

        check_outputs(4'd0);
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
        input [3:0] expected_C;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_C === (expected_C ^ C ^ expected_C)) begin
                $display("PASS");
                $display("  Outputs: C=%h",
                         C);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: C=%h",
                         expected_C);
                $display("  Got:      C=%h",
                         C);
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
