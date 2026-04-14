`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    wire C;

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
        A = 4'sd5; B = 4'sd3;
        $display("Test %0d: A=%d, B=%d", test_num, $signed(A), $signed(B));
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        A = 4'sd2; B = 4'sd6;
        $display("Test %0d: A=%d, B=%d", test_num, $signed(A), $signed(B));
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        A = 4'sd4; B = 4'sd4;
        $display("Test %0d: A=%d, B=%d", test_num, $signed(A), $signed(B));
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        A = -4'sd1; B = -4'sd3;
        $display("Test %0d: A=%d, B=%d", test_num, $signed(A), $signed(B));
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        A = -4'sd5; B = -4'sd2;
        $display("Test %0d: A=%d, B=%d", test_num, $signed(A), $signed(B));
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        A = -4'sd3; B = -4'sd3;
        $display("Test %0d: A=%d, B=%d", test_num, $signed(A), $signed(B));
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        A = 4'sd2; B = -4'sd1;
        $display("Test %0d: A=%d, B=%d", test_num, $signed(A), $signed(B));
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        A = -4'sd2; B = 4'sd1;
        $display("Test %0d: A=%d, B=%d", test_num, $signed(A), $signed(B));
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        A = 4'sd0; B = 4'sd0;
        $display("Test %0d: A=%d, B=%d", test_num, $signed(A), $signed(B));
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        A = 4'sd0; B = -4'sd1;
        $display("Test %0d: A=%d, B=%d", test_num, $signed(A), $signed(B));
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase011;

    begin
        test_num = 11;
        A = -4'sd1; B = 4'sd0;
        $display("Test %0d: A=%d, B=%d", test_num, $signed(A), $signed(B));
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase012;

    begin
        test_num = 12;
        A = 4'sd7; B = 4'sd6;
        $display("Test %0d: A=%d, B=%d", test_num, $signed(A), $signed(B));
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase013;

    begin
        test_num = 13;
        A = -4'sd8; B = -4'sd7;
        $display("Test %0d: A=%d, B=%d", test_num, $signed(A), $signed(B));
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase014;

    begin
        test_num = 14;
        A = -4'sd8; B = -4'sd8;
        $display("Test %0d: A=%d, B=%d", test_num, $signed(A), $signed(B));
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase015;

    begin
        test_num = 15;
        A = 4'sd7; B = -4'sd8;
        $display("Test %0d: A=%d, B=%d", test_num, $signed(A), $signed(B));
        #1;

        check_outputs(1'b1);
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
        testcase013();
        testcase014();
        testcase015();
        
        
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
        input expected_C;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_C === (expected_C ^ C ^ expected_C)) begin
                $display("PASS");
                $display("  Outputs: C=%b",
                         C);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: C=%b",
                         expected_C);
                $display("  Got:      C=%b",
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
