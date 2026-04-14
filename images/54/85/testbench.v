`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg A2;
    reg A3;
    reg A8;
    reg A9;
    reg AEN;
    reg F;
    reg IORbar;
    reg IOWbar;
    wire [3:0] CSbar;
    wire DIR;
    wire Ebar;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A2(A2),
        .A3(A3),
        .A8(A8),
        .A9(A9),
        .AEN(AEN),
        .F(F),
        .IORbar(IORbar),
        .IOWbar(IOWbar),
        .CSbar(CSbar),
        .DIR(DIR),
        .Ebar(Ebar)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: All signals high (Idle/Disabled)", test_num);
        A9=1; A8=1; F=1; A3=0; A2=0; AEN=1; IORbar=1; IOWbar=1;

        #1;


        check_outputs(4'hf, 1'b0, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Select CSbar[0] - Write Operation", test_num);

        A9=1; A8=1; F=1; AEN=0; A3=0; A2=0; IORbar=1; IOWbar=0;

        #1;


        check_outputs(4'hE, 1'b0, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Select CSbar[1] - Read Operation", test_num);

        A9=1; A8=1; F=1; AEN=0; A3=0; A2=1; IORbar=0; IOWbar=1;

        #1;


        check_outputs(4'hD, 1'b1, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Select CSbar[2] - Write Operation", test_num);

        A9=1; A8=1; F=1; AEN=0; A3=1; A2=0; IORbar=1; IOWbar=0;

        #1;


        check_outputs(4'hB, 1'b0, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Select CSbar[3] - Read Operation", test_num);

        A9=1; A8=1; F=1; AEN=0; A3=1; A2=1; IORbar=0; IOWbar=1;

        #1;


        check_outputs(4'h7, 1'b1, 1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Address Mismatch (A9 low)", test_num);
        A9=0; A8=1; F=1; AEN=0; A3=0; A2=0; IORbar=0; IOWbar=1;

        #1;


        check_outputs(4'hf, 1'b1, 1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Address Mismatch (F low)", test_num);
        A9=1; A8=1; F=0; AEN=0; A3=0; A2=0; IORbar=0; IOWbar=1;

        #1;


        check_outputs(4'hf, 1'b1, 1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: Address Mismatch (AEN high)", test_num);
        A9=1; A8=1; F=1; AEN=1; A3=0; A2=0; IORbar=0; IOWbar=1;

        #1;


        check_outputs(4'hf, 1'b1, 1'b1);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Testcase %0d: No Control Signal Active", test_num);
        A9=1; A8=1; F=1; AEN=0; A3=0; A2=0; IORbar=1; IOWbar=1;

        #1;


        check_outputs(4'hf, 1'b0, 1'b1);
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
        input [3:0] expected_CSbar;
        input expected_DIR;
        input expected_Ebar;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_CSbar === (expected_CSbar ^ CSbar ^ expected_CSbar) &&
                expected_DIR === (expected_DIR ^ DIR ^ expected_DIR) &&
                expected_Ebar === (expected_Ebar ^ Ebar ^ expected_Ebar)) begin
                $display("PASS");
                $display("  Outputs: CSbar=%h, DIR=%b, Ebar=%b",
                         CSbar, DIR, Ebar);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: CSbar=%h, DIR=%b, Ebar=%b",
                         expected_CSbar, expected_DIR, expected_Ebar);
                $display("  Got:      CSbar=%h, DIR=%b, Ebar=%b",
                         CSbar, DIR, Ebar);
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
