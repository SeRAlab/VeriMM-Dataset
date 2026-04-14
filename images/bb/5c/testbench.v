`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg l;
    reg m;
    reg n;
    wire v_pos;
    wire v_sop;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .l(l),
        .m(m),
        .n(n),
        .v_pos(v_pos),
        .v_sop(v_sop)
    );
    task testcase001;

    begin
        test_num = 1;
        l = 0; m = 0; n = 0;
        $display("Testcase %0d: Input (l,m,n) = (0,0,0)", test_num);
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        l = 0; m = 0; n = 1;
        $display("Testcase %0d: Input (l,m,n) = (0,0,1)", test_num);
        #1;

        check_outputs(1'b1, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        l = 0; m = 1; n = 0;
        $display("Testcase %0d: Input (l,m,n) = (0,1,0)", test_num);
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        l = 0; m = 1; n = 1;
        $display("Testcase %0d: Input (l,m,n) = (0,1,1)", test_num);
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        l = 1; m = 0; n = 0;
        $display("Testcase %0d: Input (l,m,n) = (1,0,0)", test_num);
        #1;

        check_outputs(1'b1, 1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        l = 1; m = 0; n = 1;
        $display("Testcase %0d: Input (l,m,n) = (1,0,1)", test_num);
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        l = 1; m = 1; n = 0;
        $display("Testcase %0d: Input (l,m,n) = (1,1,0)", test_num);
        #1;

        check_outputs(1'b1, 1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        l = 1; m = 1; n = 1;
        $display("Testcase %0d: Input (l,m,n) = (1,1,1)", test_num);
        #1;

        check_outputs(1'b0, 1'b0);
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
        input expected_v_pos;
        input expected_v_sop;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_v_pos === (expected_v_pos ^ v_pos ^ expected_v_pos) &&
                expected_v_sop === (expected_v_sop ^ v_sop ^ expected_v_sop)) begin
                $display("PASS");
                $display("  Outputs: v_pos=%b, v_sop=%b",
                         v_pos, v_sop);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: v_pos=%b, v_sop=%b",
                         expected_v_pos, expected_v_sop);
                $display("  Got:      v_pos=%b, v_sop=%b",
                         v_pos, v_sop);
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
