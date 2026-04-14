`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg rd;
    reg vz;
    wire rz;
    wire vd;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .rd(rd),
        .vz(vz),
        .rz(rz),
        .vd(vd)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: All inputs Low (rd=0, vz=0)", test_num);
            rd = 1'b0;
            vz = 1'b0;

            #1;


            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Ready High, Valid Low (rd=1, vz=0)", test_num);
            rd = 1'b1;
            vz = 1'b0;

            #1;


            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Ready Low, Valid High (rd=0, vz=1)", test_num);
            rd = 1'b0;
            vz = 1'b1;

            #1;


            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: All inputs High (rd=1, vz=1)", test_num);
            rd = 1'b1;
            vz = 1'b1;

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
        input expected_rz;
        input expected_vd;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_rz === (expected_rz ^ rz ^ expected_rz) &&
                expected_vd === (expected_vd ^ vd ^ expected_vd)) begin
                $display("PASS");
                $display("  Outputs: rz=%b, vd=%b",
                         rz, vd);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rz=%b, vd=%b",
                         expected_rz, expected_vd);
                $display("  Got:      rz=%b, vd=%b",
                         rz, vd);
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
