`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg VGND;
    reg VPWR;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .VGND(VGND),
        .VPWR(VPWR)
    );
    task reset_circuit;

        begin
            VPWR = 0;
            VGND = 1;
            #100;
            VPWR = 0;
            VGND = 0;
            #5;
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            reset_circuit();
            $display("Running Testcase 001: Charging for 50ns...");
            VPWR = 1;
            VGND = 0;
            #50;
            expected_voltage = 50;
            #1;

            check_outputs();
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_circuit();
            $display("Running Testcase 002: Charge 50ns, Discharge 20ns...");
            VPWR = 1; VGND = 0;
            #50;
            VPWR = 0; VGND = 1;
            #20;
            expected_voltage = 30;
            #1;

            check_outputs();
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_circuit();
            $display("Running Testcase 003: Charge 30ns, then Hold (Both Low)...");
            VPWR = 1; VGND = 0;
            #30;
            VPWR = 0; VGND = 0;
            #20;
            expected_voltage = 30;
            #1;

            check_outputs();
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_circuit();
            $display("Running Testcase 004: Charge 20ns, then Both High (Should Hold)...");
            VPWR = 1; VGND = 0;
            #20;
            VPWR = 1; VGND = 1;
            #20;
            expected_voltage = 20;
            #1;

            check_outputs();
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_circuit();
            $display("Running Testcase 005: Charge 10ns, Discharge 20ns (Floor check)...");
            VPWR = 1; VGND = 0;
            #10;
            VPWR = 0; VGND = 1;
            #20;
            expected_voltage = 0;
            #1;

            check_outputs();
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
        begin
            #1; // Small delay for combinational logic to settle
            if () begin
                $display("PASS");
                $display("  Outputs: ",
                         );
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ",
                         );
                $display("  Got:      ",
                         );
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
