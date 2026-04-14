`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg A;
    reg B;
    reg C;
    reg D;
    reg F1;
    reg FCI;
    reg SEL;
    reg WAD0;
    reg WAD1;
    reg WAD2;
    reg WAD3;
    reg WCK;
    reg WD;
    reg WRE;
    wire F;
    wire OFX;

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
        .F1(F1),
        .FCI(FCI),
        .SEL(SEL),
        .WAD0(WAD0),
        .WAD1(WAD1),
        .WAD2(WAD2),
        .WAD3(WAD3),
        .WCK(WCK),
        .WD(WD),
        .WRE(WRE),
        .F(F),
        .OFX(OFX)
    );
    task reset_inputs;

        begin
            A = 0; B = 0; C = 0; D = 0;
            SEL = 0; F1 = 0; FCI = 0;
            WAD0 = 0; WAD1 = 0; WAD2 = 0; WAD3 = 0;
            WD = 0; WCK = 0; WRE = 0;
            #10;
        end
        endtask

    task cycle_wck;

        begin
            #5 WCK = 1;
            #5 WCK = 0;
            #5;
        end
        endtask

    task testcase001;

        begin
            $display("Testcase 001: Write 1 to Address 0 and Read back...");
            reset_inputs();

            WRE = 1;
            WAD3=0; WAD2=0; WAD1=0; WAD0=0;
            WD = 1;
            cycle_wck();


            WRE = 0;
            D=0; C=0; B=0; A=0;
            SEL = 0;
            #1;

            check_outputs(1, 1);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Write 1 to Address 15 and Read back...");
            reset_inputs();

            WRE = 1;
            WAD3=1; WAD2=1; WAD1=1; WAD0=1;
            WD = 1;
            cycle_wck();


            WRE = 0;
            D=1; C=1; B=1; A=1;
            SEL = 0;
            #1;

            check_outputs(1, 1);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Verify OFX selects F1 when SEL=1...");
            reset_inputs();

            WRE = 1;
            WAD3=0; WAD2=1; WAD1=0; WAD0=1;
            WD = 0;
            cycle_wck();


            WRE = 0;
            D=0; C=1; B=0; A=1;
            F1 = 1;
            SEL = 1;
            #1;

            check_outputs(0, 1);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Verify no write occurs when WRE=0...");
            reset_inputs();

            WRE = 1;
            WAD3=0; WAD2=1; WAD1=1; WAD0=1;
            WD = 1;
            cycle_wck();


            WRE = 0;
            WD = 0;
            cycle_wck();


            D=0; C=1; B=1; A=1;
            SEL = 0;
            #1;

            check_outputs(1, 1);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Independent Read/Write Addresses...");
            reset_inputs();

            WRE = 1;
            WAD3=1; WAD2=0; WAD1=1; WAD0=0;
            WD = 1;
            cycle_wck();


            D=0; C=0; B=0; A=0;
            WAD3=1; WAD2=0; WAD1=1; WAD0=0;
            WD = 0;
            WRE = 1;
            SEL = 0;


            #1;



            check_outputs(0, 0);
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
        input expected_F;
        input expected_OFX;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_F === (expected_F ^ F ^ expected_F) &&
                expected_OFX === (expected_OFX ^ OFX ^ expected_OFX)) begin
                $display("PASS");
                $display("  Outputs: F=%b, OFX=%b",
                         F, OFX);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: F=%b, OFX=%b",
                         expected_F, expected_OFX);
                $display("  Got:      F=%b, OFX=%b",
                         F, OFX);
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
