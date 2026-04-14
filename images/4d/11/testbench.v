`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] A;
    reg [31:0] B;
    wire [31:0] C;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .C(C)
    );
    task testcase001;

    begin
        test_num = 1;
        A = 32'd0;
        B = 32'd15;
        $display("Testcase %0d: A=0, B=15 (Expect 0)", test_num);
        #1;

        check_outputs(32'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        A = 32'd15;
        B = 32'd0;
        $display("Testcase %0d: A=15, B=0 (Expect 0 due to zero B)", test_num);
        #1;

        check_outputs(32'd0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        A = 32'd17;
        B = 32'd5;
        $display("Testcase %0d: A=17, B=5 (Expect 2)", test_num);
        #1;

        check_outputs(32'd2);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        A = -32'sd20;
        B = 32'sd3;
        $display("Testcase %0d: A=-20, B=3 (Expect abs(-20)%%3 = 2)", test_num);
        #1;

        check_outputs(32'd2);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        A = 32'sd25;
        B = -32'sd7;
        $display("Testcase %0d: A=25, B=-7 (Expect 25%%abs(-7) = 4)", test_num);
        #1;

        check_outputs(32'd4);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        A = -32'sd30;
        B = -32'sd4;
        $display("Testcase %0d: A=-30, B=-4 (Expect abs(-30)%%abs(-4) = 2)", test_num);
        #1;

        check_outputs(32'd2);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        A = 32'd5;
        B = 32'd10;
        $display("Testcase %0d: A=5, B=10 (Expect 5)", test_num);
        #1;

        check_outputs(32'd5);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        A = 32'd100;
        B = 32'd10;
        $display("Testcase %0d: A=100, B=10 (Expect 0)", test_num);
        #1;

        check_outputs(32'd0);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        A = 32'h7FFFFFFF;
        B = 32'd100;
        $display("Testcase %0d: A=MaxPos, B=100 (Expect 47)", test_num);
        #1;

        check_outputs(32'd47);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        A = 32'h80000000;
        B = 32'd10;
        $display("Testcase %0d: A=MinNeg, B=10 (Expect abs(MinNeg)%%10 = 8)", test_num);
        #1;

        check_outputs(32'd8);
    end
        endtask

    task testcase011;

    begin
        test_num = 11;
        A = 32'sd123456;
        B = 32'sd123456;
        $display("Testcase %0d: A=B (Expect 0)", test_num);
        #1;

        check_outputs(32'd0);
    end
        endtask

    task testcase012;

    begin
        test_num = 12;
        A = -32'sd1;
        B = 32'sd10;
        $display("Testcase %0d: A=-1, B=10 (Expect 1)", test_num);
        #1;

        check_outputs(32'd1);
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
        testcase011();
        testcase012();
        
        
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
        input [31:0] expected_C;
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
