`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg iorq_n;
    reg iorqge1;
    reg iorqge2;
    reg m1_n;
    reg porthit;
    reg rd_n;
    reg wr_n;
    wire drive_ff;
    wire iorq1_n;
    wire iorq2_n;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .iorq_n(iorq_n),
        .iorqge1(iorqge1),
        .iorqge2(iorqge2),
        .m1_n(m1_n),
        .porthit(porthit),
        .rd_n(rd_n),
        .wr_n(wr_n),
        .drive_ff(drive_ff),
        .iorq1_n(iorq1_n),
        .iorq2_n(iorq2_n)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: Idle State (All control signals inactive)", test_num);
        iorq_n = 1; rd_n = 1; wr_n = 1; m1_n = 1; iorqge1 = 0; iorqge2 = 0; porthit = 0;
        #1;

        check_outputs(0, 1, 1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: Active I/O Read (Match, Gates ON)", test_num);
        iorq_n = 0; rd_n = 0; wr_n = 1; m1_n = 1; iorqge1 = 1; iorqge2 = 1; porthit = 1;
        #1;

        check_outputs(1, 0, 0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: Active I/O Write (Match, Gates ON)", test_num);
        iorq_n = 0; rd_n = 1; wr_n = 0; m1_n = 1; iorqge1 = 1; iorqge2 = 1; porthit = 1;
        #1;

        check_outputs(0, 0, 0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: Interrupt Acknowledge Cycle (IORQ + M1)", test_num);
        iorq_n = 0; rd_n = 0; wr_n = 1; m1_n = 0; iorqge1 = 1; iorqge2 = 1; porthit = 1;
        #1;

        check_outputs(0, 1, 1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: Active Read, Gate 1 only", test_num);
        iorq_n = 0; rd_n = 0; wr_n = 1; m1_n = 1; iorqge1 = 1; iorqge2 = 0; porthit = 1;
        #1;

        check_outputs(1, 0, 1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %0d: Active Read, Gate 2 only", test_num);
        iorq_n = 0; rd_n = 0; wr_n = 1; m1_n = 1; iorqge1 = 0; iorqge2 = 1; porthit = 1;
        #1;

        check_outputs(1, 1, 0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test %0d: Active Read, No Port Hit", test_num);
        iorq_n = 0; rd_n = 0; wr_n = 1; m1_n = 1; iorqge1 = 1; iorqge2 = 1; porthit = 0;
        #1;

        check_outputs(0, 0, 0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test %0d: Active Read, Both Gates Disabled", test_num);
        iorq_n = 0; rd_n = 0; wr_n = 1; m1_n = 1; iorqge1 = 0; iorqge2 = 0; porthit = 1;
        #1;

        check_outputs(1, 1, 1);
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
        input expected_drive_ff;
        input expected_iorq1_n;
        input expected_iorq2_n;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_drive_ff === (expected_drive_ff ^ drive_ff ^ expected_drive_ff) &&
                expected_iorq1_n === (expected_iorq1_n ^ iorq1_n ^ expected_iorq1_n) &&
                expected_iorq2_n === (expected_iorq2_n ^ iorq2_n ^ expected_iorq2_n)) begin
                $display("PASS");
                $display("  Outputs: drive_ff=%b, iorq1_n=%b, iorq2_n=%b",
                         drive_ff, iorq1_n, iorq2_n);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: drive_ff=%b, iorq1_n=%b, iorq2_n=%b",
                         expected_drive_ff, expected_iorq1_n, expected_iorq2_n);
                $display("  Got:      drive_ff=%b, iorq1_n=%b, iorq2_n=%b",
                         drive_ff, iorq1_n, iorq2_n);
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
