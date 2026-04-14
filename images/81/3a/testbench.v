`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg D;
    reg G;
    reg SN;
    wire [3:0] Q;
    wire [3:0] QN;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .D(D),
        .G(G),
        .SN(SN),
        .Q(Q),
        .QN(QN)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        SN = 0; G = 0; D = 4'h0;
        #10;
        #1;

        check_outputs(4'hF, 4'h0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        SN = 0; #5; SN = 1;
        G = 1; D = 4'hA;
        #10;
        #1;

        check_outputs(4'hA, 4'h5);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        SN = 0; #5; SN = 1;
        G = 1; D = 4'h5;
        #10;
        #1;

        check_outputs(4'h5, 4'hA);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        SN = 0; #5; SN = 1;
        G = 1; D = 4'hC;
        #5; G = 0;
        #5; D = 4'h3;
        #10;
        #1;

        check_outputs(4'hC, 4'h3);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        SN = 0; #5; SN = 1;
        G = 1; D = 4'h2;
        #5; SN = 0;
        #10;
        #1;

        check_outputs(4'hF, 4'h0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        SN = 0; #5; SN = 1;
        G = 1; D = 4'h0;
        #5; G = 0;
        #5; D = 4'hF;
        #10;
        #1;

        check_outputs(4'h0, 4'hF);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        SN = 0; G = 0; D = 4'h3;
        #5; SN = 1;
        #5; D = 4'hE;
        #10;
        #1;

        check_outputs(4'hF, 4'h0);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        SN = 0; #5; SN = 1;
        G = 1;
        D = 4'h1; #2;
        D = 4'h8; #2;
        D = 4'hB; #5;
        #1;

        check_outputs(4'hB, 4'h4);
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
        input [3:0] expected_Q;
        input [3:0] expected_QN;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Q === (expected_Q ^ Q ^ expected_Q) &&
                expected_QN === (expected_QN ^ QN ^ expected_QN)) begin
                $display("PASS");
                $display("  Outputs: Q=%h, QN=%h",
                         Q, QN);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%h, QN=%h",
                         expected_Q, expected_QN);
                $display("  Got:      Q=%h, QN=%h",
                         Q, QN);
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
