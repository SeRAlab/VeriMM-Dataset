`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg A;
    reg B;
    reg C;
    reg D;
    wire [15:0] Y;

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
        .Y(Y)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Input 0000 (D=0, C=0, B=0, A=0)", test_num);
        D = 0; C = 0; B = 0; A = 0;
        #1;

        check_outputs(16'hFFFE);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Input 0001 (D=0, C=0, B=0, A=1)", test_num);
        D = 0; C = 0; B = 0; A = 1;
        #1;

        check_outputs(16'hFFFD);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Input 0010 (D=0, C=0, B=1, A=0)", test_num);
        D = 0; C = 0; B = 1; A = 0;
        #1;

        check_outputs(16'hFFFB);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Input 0011 (D=0, C=0, B=1, A=1)", test_num);
        D = 0; C = 0; B = 1; A = 1;
        #1;

        check_outputs(16'hFFF7);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Input 0100 (D=0, C=1, B=0, A=0)", test_num);
        D = 0; C = 1; B = 0; A = 0;
        #1;

        check_outputs(16'hFFEF);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Input 0101 (D=0, C=1, B=0, A=1)", test_num);
        D = 0; C = 1; B = 0; A = 1;
        #1;

        check_outputs(16'hFFDF);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Input 0110 (D=0, C=1, B=1, A=0)", test_num);
        D = 0; C = 1; B = 1; A = 0;
        #1;

        check_outputs(16'hFFBF);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: Input 0111 (D=0, C=1, B=1, A=1)", test_num);
        D = 0; C = 1; B = 1; A = 1;
        #1;

        check_outputs(16'hFF7F);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Testcase %0d: Input 1000 (D=1, C=0, B=0, A=0)", test_num);
        D = 1; C = 0; B = 0; A = 0;
        #1;

        check_outputs(16'hFEFF);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Testcase %0d: Input 1001 (D=1, C=0, B=0, A=1)", test_num);
        D = 1; C = 0; B = 0; A = 1;
        #1;

        check_outputs(16'hFDFF);
    end
        endtask

    task testcase011;

    begin
        test_num = 11;
        $display("Testcase %0d: Input 1010 (D=1, C=0, B=1, A=0)", test_num);
        D = 1; C = 0; B = 1; A = 0;
        #1;

        check_outputs(16'hFBFF);
    end
        endtask

    task testcase012;

    begin
        test_num = 12;
        $display("Testcase %0d: Input 1011 (D=1, C=0, B=1, A=1)", test_num);
        D = 1; C = 0; B = 1; A = 1;
        #1;

        check_outputs(16'hF7FF);
    end
        endtask

    task testcase013;

    begin
        test_num = 13;
        $display("Testcase %0d: Input 1100 (D=1, C=1, B=0, A=0)", test_num);
        D = 1; C = 1; B = 0; A = 0;
        #1;

        check_outputs(16'hEFFF);
    end
        endtask

    task testcase014;

    begin
        test_num = 14;
        $display("Testcase %0d: Input 1101 (D=1, C=1, B=0, A=1)", test_num);
        D = 1; C = 1; B = 0; A = 1;
        #1;

        check_outputs(16'hDFFF);
    end
        endtask

    task testcase015;

    begin
        test_num = 15;
        $display("Testcase %0d: Input 1110 (D=1, C=1, B=1, A=0)", test_num);
        D = 1; C = 1; B = 1; A = 0;
        #1;

        check_outputs(16'hBFFF);
    end
        endtask

    task testcase016;

    begin
        test_num = 16;
        $display("Testcase %0d: Input 1111 (D=1, C=1, B=1, A=1)", test_num);
        D = 1; C = 1; B = 1; A = 1;
        #1;

        check_outputs(16'h7FFF);
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
        input [15:0] expected_Y;
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
