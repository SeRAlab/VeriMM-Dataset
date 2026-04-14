`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [6:0] NUMBER;
    wire [3:0] A;
    wire [3:0] B;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .NUMBER(NUMBER),
        .A(A),
        .B(B)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: NUMBER = 0 (Lower boundary)", test_num);
        NUMBER = 7'd0;
        #1;

        check_outputs(4'd0, 4'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: NUMBER = 9 (Units only)", test_num);
        NUMBER = 7'd9;
        #1;

        check_outputs(4'd0, 4'd9);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: NUMBER = 10 (Tens carry)", test_num);
        NUMBER = 7'd10;
        #1;

        check_outputs(4'd1, 4'd0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: NUMBER = 25 (Middle range)", test_num);
        NUMBER = 7'd25;
        #1;

        check_outputs(4'd2, 4'd5);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: NUMBER = 42 (Middle range)", test_num);
        NUMBER = 7'd42;
        #1;

        check_outputs(4'd4, 4'd2);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %0d: NUMBER = 50 (Exact tens)", test_num);
        NUMBER = 7'd50;
        #1;

        check_outputs(4'd5, 4'd0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test %0d: NUMBER = 59 (Upper boundary valid range)", test_num);
        NUMBER = 7'd59;
        #1;

        check_outputs(4'd5, 4'd9);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test %0d: NUMBER = 60 (Invalid range, expected zeros)", test_num);
        NUMBER = 7'd60;
        #1;

        check_outputs(4'd0, 4'd0);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test %0d: NUMBER = 100 (Invalid range, expected zeros)", test_num);
        NUMBER = 7'd100;
        #1;

        check_outputs(4'd0, 4'd0);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Test %0d: NUMBER = 127 (Max input, expected zeros)", test_num);
        NUMBER = 7'd127;
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
        input [3:0] expected_A;
        input [3:0] expected_B;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_A === (expected_A ^ A ^ expected_A) &&
                expected_B === (expected_B ^ B ^ expected_B)) begin
                $display("PASS");
                $display("  Outputs: A=%h, B=%h",
                         A, B);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: A=%h, B=%h",
                         expected_A, expected_B);
                $display("  Got:      A=%h, B=%h",
                         A, B);
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
