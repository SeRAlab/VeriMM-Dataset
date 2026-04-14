`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] A;
    reg [1:0] B;
    reg VGND;
    reg VNB;
    reg VPB;
    reg VPWR;
    wire EQ;
    wire GT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .VGND(VGND),
        .VNB(VNB),
        .VPB(VPB),
        .VPWR(VPWR),
        .EQ(EQ),
        .GT(GT)
    );
    task testcase001;

        begin
            test_num = 1;
            A = 2'b00; B = 2'b00;
            VGND = 1'b0; VNB = 1'b0; VPB = 1'b1; VPWR = 1'b1;
            $display("Test Case 001: A=0, B=0 (Expected EQ=1, GT=0)");
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            A = 2'b00; B = 2'b01;
            VGND = 1'b0; VNB = 1'b0; VPB = 1'b1; VPWR = 1'b1;
            $display("Test Case 002: A=0, B=1 (Expected EQ=0, GT=0)");
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            A = 2'b00; B = 2'b10;
            VGND = 1'b0; VNB = 1'b0; VPB = 1'b1; VPWR = 1'b1;
            $display("Test Case 003: A=0, B=2 (Expected EQ=0, GT=0)");
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            A = 2'b00; B = 2'b11;
            VGND = 1'b0; VNB = 1'b0; VPB = 1'b1; VPWR = 1'b1;
            $display("Test Case 004: A=0, B=3 (Expected EQ=0, GT=0)");
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            A = 2'b01; B = 2'b00;
            VGND = 1'b0; VNB = 1'b0; VPB = 1'b1; VPWR = 1'b1;
            $display("Test Case 005: A=1, B=0 (Expected EQ=0, GT=1)");
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            A = 2'b01; B = 2'b01;
            VGND = 1'b0; VNB = 1'b0; VPB = 1'b1; VPWR = 1'b1;
            $display("Test Case 006: A=1, B=1 (Expected EQ=1, GT=0)");
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            A = 2'b01; B = 2'b10;
            VGND = 1'b0; VNB = 1'b0; VPB = 1'b1; VPWR = 1'b1;
            $display("Test Case 007: A=1, B=2 (Expected EQ=0, GT=0)");
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            A = 2'b01; B = 2'b11;
            VGND = 1'b0; VNB = 1'b0; VPB = 1'b1; VPWR = 1'b1;
            $display("Test Case 008: A=1, B=3 (Expected EQ=0, GT=0)");
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            A = 2'b10; B = 2'b00;
            VGND = 1'b0; VNB = 1'b0; VPB = 1'b1; VPWR = 1'b1;
            $display("Test Case 009: A=2, B=0 (Expected EQ=0, GT=1)");
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            A = 2'b10; B = 2'b01;
            VGND = 1'b0; VNB = 1'b0; VPB = 1'b1; VPWR = 1'b1;
            $display("Test Case 010: A=2, B=1 (Expected EQ=0, GT=1)");
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase011;

        begin
            test_num = 11;
            A = 2'b10; B = 2'b10;
            VGND = 1'b0; VNB = 1'b0; VPB = 1'b1; VPWR = 1'b1;
            $display("Test Case 011: A=2, B=2 (Expected EQ=1, GT=0)");
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase012;

        begin
            test_num = 12;
            A = 2'b10; B = 2'b11;
            VGND = 1'b0; VNB = 1'b0; VPB = 1'b1; VPWR = 1'b1;
            $display("Test Case 012: A=2, B=3 (Expected EQ=0, GT=0)");
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase013;

        begin
            test_num = 13;
            A = 2'b11; B = 2'b00;
            VGND = 1'b0; VNB = 1'b0; VPB = 1'b1; VPWR = 1'b1;
            $display("Test Case 013: A=3, B=0 (Expected EQ=0, GT=1)");
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase014;

        begin
            test_num = 14;
            A = 2'b11; B = 2'b01;
            VGND = 1'b0; VNB = 1'b0; VPB = 1'b1; VPWR = 1'b1;
            $display("Test Case 014: A=3, B=1 (Expected EQ=0, GT=1)");
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase015;

        begin
            test_num = 15;
            A = 2'b11; B = 2'b10;
            VGND = 1'b0; VNB = 1'b0; VPB = 1'b1; VPWR = 1'b1;
            $display("Test Case 015: A=3, B=2 (Expected EQ=0, GT=1)");
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase016;

        begin
            test_num = 16;
            A = 2'b11; B = 2'b11;
            VGND = 1'b0; VNB = 1'b0; VPB = 1'b1; VPWR = 1'b1;
            $display("Test Case 016: A=3, B=3 (Expected EQ=1, GT=0)");
            #1;

            check_outputs(1'b1, 1'b0);
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
        testcase016();
        
        
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
        input expected_EQ;
        input expected_GT;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_EQ === (expected_EQ ^ EQ ^ expected_EQ) &&
                expected_GT === (expected_GT ^ GT ^ expected_GT)) begin
                $display("PASS");
                $display("  Outputs: EQ=%b, GT=%b",
                         EQ, GT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: EQ=%b, GT=%b",
                         expected_EQ, expected_GT);
                $display("  Got:      EQ=%b, GT=%b",
                         EQ, GT);
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
