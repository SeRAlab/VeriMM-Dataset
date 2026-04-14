`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg din_0;
    reg din_1;
    reg din_2;
    reg en;
    wire dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .din_0(din_0),
        .din_1(din_1),
        .din_2(din_2),
        .en(en),
        .dout(dout)
    );
    task testcase001;

        begin
            $display("Testcase 001: High Impedance State (en=0, all din=0)");
            test_num = 1;
            en = 0;
            din_0 = 0;
            din_1 = 0;
            din_2 = 0;
            #1;

            check_outputs(1'bz);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: High Impedance State (en=0, din_0=1)");
            test_num = 2;
            en = 0;
            din_0 = 1;
            din_1 = 0;
            din_2 = 0;
            #1;

            check_outputs(1'bz);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Select din_0 (en=1, din_0=1, din_1=0, din_2=0)");
            test_num = 3;
            en = 1;
            din_0 = 1;
            din_1 = 0;
            din_2 = 0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Select din_1 (en=1, din_0=0, din_1=1, din_2=0)");
            test_num = 4;
            en = 1;
            din_0 = 0;
            din_1 = 1;
            din_2 = 0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Select din_2 (en=1, din_0=0, din_1=0, din_2=1)");
            test_num = 5;
            en = 1;
            din_0 = 0;
            din_1 = 0;
            din_2 = 1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: All Inputs Low (en=1, din_0=0, din_1=0, din_2=0)");
            test_num = 6;
            en = 1;
            din_0 = 0;
            din_1 = 0;
            din_2 = 0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: High Impedance with Multiple Inputs Set (en=0)");
            test_num = 7;
            en = 0;
            din_0 = 1;
            din_1 = 1;
            din_2 = 1;
            #1;

            check_outputs(1'bz);
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
        input expected_dout;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_dout === (expected_dout ^ dout ^ expected_dout)) begin
                $display("PASS");
                $display("  Outputs: dout=%b",
                         dout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dout=%b",
                         expected_dout);
                $display("  Got:      dout=%b",
                         dout);
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
