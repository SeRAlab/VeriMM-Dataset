`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg CLK;
    reg EN_get;
    reg EN_put;
    reg RST;
    reg put;
    wire RDY_get;
    wire RDY_put;
    wire get;
    wire inverseReady;
    wire modReady;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .EN_get(EN_get),
        .EN_put(EN_put),
        .RST(RST),
        .put(put),
        .RDY_get(RDY_get),
        .RDY_put(RDY_put),
        .get(get),
        .inverseReady(inverseReady),
        .modReady(modReady)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %0d...", test_num);
        RST = 1; EN_get = 0; EN_put = 0; put = 0;
        #20 RST = 0;
        #10;

        #1;


        check_outputs(1, 1, 0, 1, 0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %0d...", test_num);
        RST = 1; #20 RST = 0;
        put = 1; EN_get = 0; EN_put = 0;
        #10;

        #1;


        check_outputs(1, 1, 1, 1, 0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %0d...", test_num);
        RST = 1; #20 RST = 0;
        put = 0; EN_get = 0; EN_put = 1;
        #10;

        #1;


        check_outputs(1, 1, 0, 0, 0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %0d...", test_num);
        RST = 1; #20 RST = 0;
        put = 1; EN_get = 1; EN_put = 0;
        #10;

        #1;


        check_outputs(1, 1, 1, 1, 1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %0d...", test_num);
        RST = 1; #20 RST = 0;
        put = 1; EN_get = 1; EN_put = 1;
        #10;

        #1;


        check_outputs(1, 1, 1, 0, 1);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %0d...", test_num);
        RST = 1; #20 RST = 0;
        EN_get = 1; EN_put = 1;
        put = 1; #10;
        put = 0; #10;

        #1;


        check_outputs(1, 1, 0, 0, 1);
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
        input expected_RDY_get;
        input expected_RDY_put;
        input expected_get;
        input expected_inverseReady;
        input expected_modReady;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_RDY_get === (expected_RDY_get ^ RDY_get ^ expected_RDY_get) &&
                expected_RDY_put === (expected_RDY_put ^ RDY_put ^ expected_RDY_put) &&
                expected_get === (expected_get ^ get ^ expected_get) &&
                expected_inverseReady === (expected_inverseReady ^ inverseReady ^ expected_inverseReady) &&
                expected_modReady === (expected_modReady ^ modReady ^ expected_modReady)) begin
                $display("PASS");
                $display("  Outputs: RDY_get=%b, RDY_put=%b, get=%b, inverseReady=%b, modReady=%b",
                         RDY_get, RDY_put, get, inverseReady, modReady);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: RDY_get=%b, RDY_put=%b, get=%b, inverseReady=%b, modReady=%b",
                         expected_RDY_get, expected_RDY_put, expected_get, expected_inverseReady, expected_modReady);
                $display("  Got:      RDY_get=%b, RDY_put=%b, get=%b, inverseReady=%b, modReady=%b",
                         RDY_get, RDY_put, get, inverseReady, modReady);
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
