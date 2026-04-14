`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg in;
    wire outl;
    wire outm;
    wire outp;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in(in),
        .outl(outl),
        .outm(outm),
        .outp(outp)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase 001: input in = 0");
        in = 1'b0;



        #1;




        check_outputs(1'b0, 1'b0, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase 002: input in = 1");
        in = 1'b1;



        #1;




        check_outputs(1'b1, 1'b1, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase 003: toggle back to in = 0");
        in = 1'b0;

        #1;


        check_outputs(1'b0, 1'b0, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase 004: toggle back to in = 1");
        in = 1'b1;

        #1;


        check_outputs(1'b1, 1'b1, 1'b0);
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
        input expected_outl;
        input expected_outm;
        input expected_outp;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_outl === (expected_outl ^ outl ^ expected_outl) &&
                expected_outm === (expected_outm ^ outm ^ expected_outm) &&
                expected_outp === (expected_outp ^ outp ^ expected_outp)) begin
                $display("PASS");
                $display("  Outputs: outl=%b, outm=%b, outp=%b",
                         outl, outm, outp);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: outl=%b, outm=%b, outp=%b",
                         expected_outl, expected_outm, expected_outp);
                $display("  Got:      outl=%b, outm=%b, outp=%b",
                         outl, outm, outp);
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
