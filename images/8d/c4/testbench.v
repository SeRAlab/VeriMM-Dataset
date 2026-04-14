`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [9:0] address;
    reg clock;
    wire [11:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .address(address),
        .clock(clock),
        .q(q)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Address 0, Clock Low (Expected: 12'h000)", test_num);
        address = 10'h000;
        clock = 1'b0;
        #1;

        check_outputs(12'h000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Address 0, Clock High (Expected: 12'hFFF)", test_num);
        address = 10'h000;
        clock = 1'b1;
        #1;

        check_outputs(12'hFFF);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Max Address, Clock Low (Expected: 12'hFFC)", test_num);
        address = 10'h3FF;
        clock = 1'b0;
        #1;

        check_outputs(12'hFFC);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Max Address, Clock High (Expected: 12'h003)", test_num);
        address = 10'h3FF;
        clock = 1'b1;
        #1;

        check_outputs(12'h003);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Pattern 0x155, Clock Low (Expected: 12'h554)", test_num);
        address = 10'h155;
        clock = 1'b0;
        #1;

        check_outputs(12'h554);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Pattern 0x155, Clock High (Expected: 12'hAAB)", test_num);
        address = 10'h155;
        clock = 1'b1;
        #1;

        check_outputs(12'hAAB);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Pattern 0x2AA, Clock Low (Expected: 12'hAA8)", test_num);
        address = 10'h2AA;
        clock = 1'b0;
        #1;

        check_outputs(12'hAA8);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: Pattern 0x2AA, Clock High (Expected: 12'h557)", test_num);
        address = 10'h2AA;
        clock = 1'b1;
        #1;

        check_outputs(12'h557);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Testcase %0d: Single Bit Address 10'h001, Clock Low (Expected: 12'h004)", test_num);
        address = 10'h001;
        clock = 1'b0;
        #1;

        check_outputs(12'h004);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Testcase %0d: Single Bit Address 10'h001, Clock High (Expected: 12'hFFB)", test_num);
        address = 10'h001;
        clock = 1'b1;
        #1;

        check_outputs(12'hFFB);
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
        input [11:0] expected_q;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%h",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h",
                         expected_q);
                $display("  Got:      q=%h",
                         q);
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
