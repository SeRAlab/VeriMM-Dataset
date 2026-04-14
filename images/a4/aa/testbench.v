`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg bsr;
    reg jcy;
    reg jmp;
    reg jne;
    reg jov;
    reg jze;
    reg [31:0] psr;
    reg ret;
    wire ifu_bsr;
    wire ifu_jmp;
    wire ifu_ret;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .bsr(bsr),
        .jcy(jcy),
        .jmp(jmp),
        .jne(jne),
        .jov(jov),
        .jze(jze),
        .psr(psr),
        .ret(ret),
        .ifu_bsr(ifu_bsr),
        .ifu_jmp(ifu_jmp),
        .ifu_ret(ifu_ret)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Unconditional Jump (jmp=1)", test_num);
            jze = 0; jne = 0; jcy = 0; jov = 0; jmp = 1; bsr = 0; ret = 0; psr = 32'h0;
            #1;

            check_outputs(0, 1, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Jump if Zero (jze=1, PSR[0]=1)", test_num);
            jze = 1; jne = 0; jcy = 0; jov = 0; jmp = 0; bsr = 0; ret = 0; psr = 32'h1;
            #1;

            check_outputs(0, 1, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Jump if Zero - Condition Not Met (jze=1, PSR[0]=0)", test_num);
            jze = 1; jne = 0; jcy = 0; jov = 0; jmp = 0; bsr = 0; ret = 0; psr = 32'h0;
            #1;

            check_outputs(0, 0, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Jump if Not Equal (jne=1, PSR[0]=0)", test_num);
            jze = 0; jne = 1; jcy = 0; jov = 0; jmp = 0; bsr = 0; ret = 0; psr = 32'h0;
            #1;

            check_outputs(0, 1, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Jump if Not Equal - Condition Not Met (jne=1, PSR[0]=1)", test_num);
            jze = 0; jne = 1; jcy = 0; jov = 0; jmp = 0; bsr = 0; ret = 0; psr = 32'h1;
            #1;

            check_outputs(0, 0, 0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Jump if Carry (jcy=1, PSR[1]=1)", test_num);
            jze = 0; jne = 0; jcy = 1; jov = 0; jmp = 0; bsr = 0; ret = 0; psr = 32'h2;
            #1;

            check_outputs(0, 1, 0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Jump if Carry - Condition Not Met (jcy=1, PSR[1]=0)", test_num);
            jze = 0; jne = 0; jcy = 1; jov = 0; jmp = 0; bsr = 0; ret = 0; psr = 32'h0;
            #1;

            check_outputs(0, 0, 0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Jump if Overflow (jov=1, PSR[2]=1)", test_num);
            jze = 0; jne = 0; jcy = 0; jov = 1; jmp = 0; bsr = 0; ret = 0; psr = 32'h4;
            #1;

            check_outputs(0, 1, 0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Branch to Subroutine (bsr=1)", test_num);
            jze = 0; jne = 0; jcy = 0; jov = 0; jmp = 0; bsr = 1; ret = 0; psr = 32'h0;
            #1;

            check_outputs(1, 0, 0);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Return (ret=1)", test_num);
            jze = 0; jne = 0; jcy = 0; jov = 0; jmp = 0; bsr = 0; ret = 1; psr = 32'h0;
            #1;

            check_outputs(0, 0, 1);
        end
        endtask

    task testcase011;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Multiple Conditions Met (jmp=1, jze=1, Z=1)", test_num);
            jze = 1; jne = 0; jcy = 0; jov = 0; jmp = 1; bsr = 0; ret = 0; psr = 32'h1;
            #1;

            check_outputs(0, 1, 0);
        end
        endtask

    task testcase012;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: No Conditions Met", test_num);
            jze = 0; jne = 0; jcy = 0; jov = 0; jmp = 0; bsr = 0; ret = 0; psr = 32'hFFFFFFFF;
            #1;

            check_outputs(0, 0, 0);
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
        input expected_ifu_bsr;
        input expected_ifu_jmp;
        input expected_ifu_ret;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ifu_bsr === (expected_ifu_bsr ^ ifu_bsr ^ expected_ifu_bsr) &&
                expected_ifu_jmp === (expected_ifu_jmp ^ ifu_jmp ^ expected_ifu_jmp) &&
                expected_ifu_ret === (expected_ifu_ret ^ ifu_ret ^ expected_ifu_ret)) begin
                $display("PASS");
                $display("  Outputs: ifu_bsr=%b, ifu_jmp=%b, ifu_ret=%b",
                         ifu_bsr, ifu_jmp, ifu_ret);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ifu_bsr=%b, ifu_jmp=%b, ifu_ret=%b",
                         expected_ifu_bsr, expected_ifu_jmp, expected_ifu_ret);
                $display("  Got:      ifu_bsr=%b, ifu_jmp=%b, ifu_ret=%b",
                         ifu_bsr, ifu_jmp, ifu_ret);
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
