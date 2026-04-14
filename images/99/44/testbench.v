`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] register;
    reg [31:0] shifts;
    wire [31:0] zhigh;
    wire [31:0] zlow;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .register(register),
        .shifts(shifts),
        .zhigh(zhigh),
        .zlow(zlow)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: All zeros input", test_num);
        register = 32'h00000000;
        shifts = 32'h00000000;

        #1;


        check_outputs(32'h00000000, 32'h00000000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Logical left shift of LSB", test_num);
        register = 32'h00000001;
        shifts = 32'h00000000;

        #1;


        check_outputs(32'h00000000, 32'h00000002);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Shift with bit discarding (MSB is 1)", test_num);
        register = 32'h80000000;
        shifts = 32'h00000000;

        #1;


        check_outputs(32'h00000000, 32'h00000000);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: All ones input", test_num);
        register = 32'hFFFFFFFF;
        shifts = 32'h00000000;

        #1;


        check_outputs(32'h00000000, 32'hFFFFFFFE);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Pattern 0x55555555", test_num);
        register = 32'h55555555;
        shifts = 32'h00000000;

        #1;


        check_outputs(32'h00000000, 32'hAAAAAAAA);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Pattern 0xAAAAAAAA", test_num);
        register = 32'hAAAAAAAA;
        shifts = 32'h00000000;

        #1;


        check_outputs(32'h00000000, 32'h55555554);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Arbitrary value check", test_num);
        register = 32'h12345678;
        shifts = 32'hFFFFFFFF;

        #1;


        check_outputs(32'h00000000, 32'h2468ACF0);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Verify zhigh is always zero", test_num);
        register = 32'hFEDCBA98;
        shifts = 32'h00000005;

        #1;


        check_outputs(32'h00000000, 32'hFDB97530);
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
        input [31:0] expected_zhigh;
        input [31:0] expected_zlow;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_zhigh === (expected_zhigh ^ zhigh ^ expected_zhigh) &&
                expected_zlow === (expected_zlow ^ zlow ^ expected_zlow)) begin
                $display("PASS");
                $display("  Outputs: zhigh=%h, zlow=%h",
                         zhigh, zlow);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: zhigh=%h, zlow=%h",
                         expected_zhigh, expected_zlow);
                $display("  Got:      zhigh=%h, zlow=%h",
                         zhigh, zlow);
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
