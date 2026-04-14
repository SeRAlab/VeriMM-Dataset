`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] bus2ip_addr_i_reg_2;
    reg [3:0] bus2ip_addr_i_reg_3;
    reg start2;
    wire ce_expnd_i_3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .bus2ip_addr_i_reg_2(bus2ip_addr_i_reg_2),
        .bus2ip_addr_i_reg_3(bus2ip_addr_i_reg_3),
        .start2(start2),
        .ce_expnd_i_3(ce_expnd_i_3)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: start2=1, bus2ip_addr_i_reg_2[3]=1", test_num);
            start2 = 1'b1;
            bus2ip_addr_i_reg_2 = 4'b1000;
            bus2ip_addr_i_reg_3 = 4'b0000;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: start2=1, bus2ip_addr_i_reg_2[3]=0", test_num);
            start2 = 1'b1;
            bus2ip_addr_i_reg_2 = 4'b0111;
            bus2ip_addr_i_reg_3 = 4'b1111;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: start2=0, bus2ip_addr_i_reg_2[2]=1", test_num);
            start2 = 1'b0;
            bus2ip_addr_i_reg_2 = 4'b0100;
            bus2ip_addr_i_reg_3 = 4'b0000;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: start2=0, bus2ip_addr_i_reg_2[2]=0", test_num);
            start2 = 1'b0;
            bus2ip_addr_i_reg_2 = 4'b1011;
            bus2ip_addr_i_reg_3 = 4'b1111;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: start2=1, ignore other bits of reg_2", test_num);
            start2 = 1'b1;
            bus2ip_addr_i_reg_2 = 4'b1111;
            bus2ip_addr_i_reg_3 = 4'b0000;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: start2=0, ignore other bits of reg_2 and reg_3", test_num);
            start2 = 1'b0;
            bus2ip_addr_i_reg_2 = 4'b1011;
            bus2ip_addr_i_reg_3 = 4'b1111;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: toggle check", test_num);
            start2 = 1'b1;
            bus2ip_addr_i_reg_2 = 4'b1000;
            #5;
            start2 = 1'b0;
            bus2ip_addr_i_reg_2 = 4'b1000;
            #1;

            check_outputs(1'b0);
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
        input expected_ce_expnd_i_3;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ce_expnd_i_3 === (expected_ce_expnd_i_3 ^ ce_expnd_i_3 ^ expected_ce_expnd_i_3)) begin
                $display("PASS");
                $display("  Outputs: ce_expnd_i_3=%b",
                         ce_expnd_i_3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ce_expnd_i_3=%b",
                         expected_ce_expnd_i_3);
                $display("  Got:      ce_expnd_i_3=%b",
                         ce_expnd_i_3);
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
