`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg dataa;
    reg datab;
    reg datac;
    reg datad;
    reg [15:0] mask;
    wire lut4;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .dataa(dataa),
        .datab(datab),
        .datac(datac),
        .datad(datad),
        .mask(mask),
        .lut4(lut4)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Check mask bit 0 (Index 0000)", test_num);
        mask = 16'h0001;
        dataa = 0; datab = 0; datac = 0; datad = 0;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Check mask bit 0 when index is 0001", test_num);
        mask = 16'h0001;
        dataa = 0; datab = 0; datac = 0; datad = 1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Check mask bit 15 (Index 1111)", test_num);
        mask = 16'h8000;
        dataa = 1; datab = 1; datac = 1; datad = 1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Check mask bit 15 when index is 0000", test_num);
        mask = 16'h8000;
        dataa = 0; datab = 0; datac = 0; datad = 0;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Check alternating pattern mask 0xAAAA (Index 0)", test_num);
        mask = 16'hAAAA;
        dataa = 0; datab = 0; datac = 0; datad = 0;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Check alternating pattern mask 0xAAAA (Index 1)", test_num);
        mask = 16'hAAAA;
        dataa = 0; datab = 0; datac = 0; datad = 1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Check all-ones mask (Index 10)", test_num);
        mask = 16'hFFFF;
        dataa = 1; datab = 0; datac = 1; datad = 0;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: Check all-zeros mask (Index 7)", test_num);
        mask = 16'h0000;
        dataa = 0; datab = 1; datac = 1; datad = 1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Testcase %0d: Arbitrary pattern 0xC3A5 (Index 5)", test_num);
        mask = 16'hC3A5;
        dataa = 0; datab = 1; datac = 0; datad = 1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Testcase %0d: Arbitrary pattern 0xC3A5 (Index 6)", test_num);
        mask = 16'hC3A5;
        dataa = 0; datab = 1; datac = 1; datad = 0;
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
        testcase009();
        testcase010();
        
        
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
        input expected_lut4;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_lut4 === (expected_lut4 ^ lut4 ^ expected_lut4)) begin
                $display("PASS");
                $display("  Outputs: lut4=%b",
                         lut4);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: lut4=%b",
                         expected_lut4);
                $display("  Got:      lut4=%b",
                         lut4);
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
