`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg Iconst;
    reg Rload;
    reg Vdd;
    wire Vload;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Iconst(Iconst),
        .Rload(Rload),
        .Vdd(Vdd),
        .Vload(Vload)
    );
    task testcase001;

    begin
        test_num = 1;
        Vdd = 0; Rload = 0; Iconst = 0;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        Vdd = 1; Rload = 0; Iconst = 0;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        Vdd = 0; Rload = 1; Iconst = 1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        Vdd = 1; Rload = 0; Iconst = 1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        Vdd = 1; Rload = 1; Iconst = 0;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        Vdd = 1; Rload = 1; Iconst = 1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        Vdd = 1; Rload = 1; Iconst = 1;
        #5;
        Vdd = 0;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        Vdd = 1; Rload = 1; Iconst = 1;
        #5;
        Rload = 0;
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
        input expected_Vload;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Vload === (expected_Vload ^ Vload ^ expected_Vload)) begin
                $display("PASS");
                $display("  Outputs: Vload=%b",
                         Vload);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Vload=%b",
                         expected_Vload);
                $display("  Got:      Vload=%b",
                         Vload);
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
