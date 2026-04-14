`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg C;
    reg CLRbar;
    reg D;
    reg PREbar;
    reg Wen;
    wire Q;
    wire Qbar;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .C(C),
        .CLRbar(CLRbar),
        .D(D),
        .PREbar(PREbar),
        .Wen(Wen),
        .Q(Q),
        .Qbar(Qbar)
    );
    task testcase001;

    begin
        $display("Test 001: Asynchronous Clear Priority (CLRbar=0)");
        test_num = 1;

        C = 0; D = 1; Wen = 1; PREbar = 1; CLRbar = 0;
        #10;

        #1;


        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase002;

    begin
        $display("Test 002: Asynchronous Preset Priority (PREbar=0)");
        test_num = 2;

        C = 0; D = 0; Wen = 1; PREbar = 0; CLRbar = 1;
        #10;

        #1;


        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase003;

    begin
        $display("Test 003: Synchronous Capture Data High (Wen=1)");
        test_num = 3;

        PREbar = 1; CLRbar = 0; #5;
        CLRbar = 1;


        C = 0; Wen = 1; D = 1;
        #5;
        C = 1;
        #5;
        #1;

        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase004;

    begin
        $display("Test 004: Synchronous Capture Data Low (Wen=1)");
        test_num = 4;

        PREbar = 0; CLRbar = 1; #5;
        PREbar = 1;


        C = 0; Wen = 1; D = 0;
        #5;
        C = 1;
        #5;
        #1;

        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase005;

    begin
        $display("Test 005: Write Enable Inactive (Wen=0)");
        test_num = 5;

        PREbar = 0; CLRbar = 1; #5;
        PREbar = 1;


        C = 0; Wen = 0; D = 0;
        #5;
        C = 1;
        #5;

        #1;


        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase006;

    begin
        $display("Test 006: Data Persistence without Clock Edge");
        test_num = 6;

        PREbar = 1; CLRbar = 0; #5;
        CLRbar = 1;


        C = 0; Wen = 1; D = 1;
        #10;

        #1;


        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase007;

    begin
        $display("Test 007: Overriding Synchronous Write with Asynchronous Clear");
        test_num = 7;

        PREbar = 1; CLRbar = 1; C = 0; Wen = 1; D = 1;
        #5;

        CLRbar = 0;
        C = 1;
        #5;

        #1;


        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase008;

    begin
        $display("Test 008: NAND-based Special Case (PREbar=0, CLRbar=0)");
        test_num = 8;

        C = 0; Wen = 0; D = 0;

        PREbar = 0; CLRbar = 0;
        #10;

        #1;


        check_outputs(1'b1, 1'b1);
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
        input expected_Q;
        input expected_Qbar;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Q === (expected_Q ^ Q ^ expected_Q) &&
                expected_Qbar === (expected_Qbar ^ Qbar ^ expected_Qbar)) begin
                $display("PASS");
                $display("  Outputs: Q=%b, Qbar=%b",
                         Q, Qbar);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%b, Qbar=%b",
                         expected_Q, expected_Qbar);
                $display("  Got:      Q=%b, Qbar=%b",
                         Q, Qbar);
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
