`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg fooc2_qual;
    reg foocr_we;
    reg ioclrinst;
    reg [2:0] tstate;
    wire ioclrtmout;
    wire [2:0] ntstate;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .fooc2_qual(fooc2_qual),
        .foocr_we(foocr_we),
        .ioclrinst(ioclrinst),
        .tstate(tstate),
        .ioclrtmout(ioclrtmout),
        .ntstate(ntstate)
    );
    task testcase001;

    begin
        test_num = 1;
        tstate = IDLE; foocr_we = 1; ioclrinst = 0; fooc2_qual = 0;
        $display("Testcase %0d: IDLE with foocr_we=1", test_num);
        #1;

        check_outputs(1'b0, TCN1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        tstate = IDLE; foocr_we = 0; ioclrinst = 0; fooc2_qual = 0;
        $display("Testcase %0d: IDLE with foocr_we=0", test_num);
        #1;

        check_outputs(1'b0, IDLE);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        tstate = TCN1; foocr_we = 0; ioclrinst = 0; fooc2_qual = 0;
        $display("Testcase %0d: TCN1 normal transition", test_num);
        #1;

        check_outputs(1'b0, TCN2);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        tstate = TCN2; foocr_we = 0; ioclrinst = 0; fooc2_qual = 0;
        $display("Testcase %0d: TCN2 normal transition", test_num);
        #1;

        check_outputs(1'b0, TCN3);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        tstate = TCN3; foocr_we = 0; ioclrinst = 0; fooc2_qual = 0;
        $display("Testcase %0d: TCN3 normal transition", test_num);
        #1;

        check_outputs(1'b0, TCN4);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        tstate = TCN4; foocr_we = 0; ioclrinst = 0; fooc2_qual = 0;
        $display("Testcase %0d: TCN4 normal transition", test_num);
        #1;

        check_outputs(1'b0, TCN5);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        tstate = TCN5; foocr_we = 0; ioclrinst = 0; fooc2_qual = 0;
        $display("Testcase %0d: TCN5 reaching IOCLR transition", test_num);
        #1;

        check_outputs(1'b0, IOCLR);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        tstate = IOCLR; foocr_we = 0; ioclrinst = 0; fooc2_qual = 0;
        $display("Testcase %0d: In IOCLR state, check ioclrtmout", test_num);
        #1;

        check_outputs(1'b1, IDLE);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        tstate = TCN2; foocr_we = 0; ioclrinst = 1; fooc2_qual = 0;
        $display("Testcase %0d: TCN2 with ioclrinst=1", test_num);
        #1;

        check_outputs(1'b0, IDLE);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        tstate = TCN4; foocr_we = 0; ioclrinst = 0; fooc2_qual = 1;
        $display("Testcase %0d: TCN4 with fooc2_qual=1", test_num);
        #1;

        check_outputs(1'b0, IDLE);
    end
        endtask

    task testcase011;

    begin
        test_num = 11;
        tstate = TCN5; foocr_we = 0; ioclrinst = 1; fooc2_qual = 0;
        $display("Testcase %0d: TCN5 with ioclrinst=1 (should not go to IOCLR)", test_num);
        #1;

        check_outputs(1'b0, IDLE);
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
        input expected_ioclrtmout;
        input [2:0] expected_ntstate;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ioclrtmout === (expected_ioclrtmout ^ ioclrtmout ^ expected_ioclrtmout) &&
                expected_ntstate === (expected_ntstate ^ ntstate ^ expected_ntstate)) begin
                $display("PASS");
                $display("  Outputs: ioclrtmout=%b, ntstate=%h",
                         ioclrtmout, ntstate);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ioclrtmout=%b, ntstate=%h",
                         expected_ioclrtmout, expected_ntstate);
                $display("  Got:      ioclrtmout=%b, ntstate=%h",
                         ioclrtmout, ntstate);
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
