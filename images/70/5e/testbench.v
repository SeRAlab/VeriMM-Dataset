`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] A;
    reg [31:0] B;
    reg [31:0] C;
    reg [31:0] D;
    reg [1:0] S;
    wire [31:0] Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .C(C),
        .D(D),
        .S(S),
        .Y(Y)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Select Input A (S=00)", test_num);
            A = 32'hDEAD_BEEF;
            B = 32'h1111_1111;
            C = 32'h2222_2222;
            D = 32'h3333_3333;
            S = 2'b00;
            #1;

            check_outputs(32'hDEAD_BEEF);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Select Input B (S=01)", test_num);
            A = 32'hAAAA_AAAA;
            B = 32'h5555_5555;
            C = 32'hCCCC_CCCC;
            D = 32'h3333_3333;
            S = 2'b01;
            #1;

            check_outputs(32'h5555_5555);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Select Input C (S=10)", test_num);
            A = 32'h0000_0001;
            B = 32'h0000_0002;
            C = 32'hCAFE_BABE;
            D = 32'h0000_0004;
            S = 2'b10;
            #1;

            check_outputs(32'hCAFE_BABE);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Select Input D (S=11)", test_num);
            A = 32'hF0F0_F0F0;
            B = 32'h0F0F_0F0F;
            C = 32'hFFFF_0000;
            D = 32'h1234_5678;
            S = 2'b11;
            #1;

            check_outputs(32'h1234_5678);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: All inputs zero, select C", test_num);
            A = 32'h0; B = 32'h0; C = 32'h0; D = 32'h0;
            S = 2'b10;
            #1;

            check_outputs(32'h0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: All inputs all ones, select D", test_num);
            A = 32'hFFFF_FFFF; B = 32'hFFFF_FFFF; C = 32'hFFFF_FFFF; D = 32'hFFFF_FFFF;
            S = 2'b11;
            #1;

            check_outputs(32'hFFFF_FFFF);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Select B with varied inputs", test_num);
            A = 32'h8888_8888;
            B = 32'h9999_9999;
            C = 32'hAAAA_AAAA;
            D = 32'hBBBB_BBBB;
            S = 2'b01;
            #1;

            check_outputs(32'h9999_9999);
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
        input [31:0] expected_Y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Y === (expected_Y ^ Y ^ expected_Y)) begin
                $display("PASS");
                $display("  Outputs: Y=%h",
                         Y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Y=%h",
                         expected_Y);
                $display("  Got:      Y=%h",
                         Y);
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
