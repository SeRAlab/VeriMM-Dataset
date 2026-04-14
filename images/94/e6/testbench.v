`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg en;
    reg [7:0] i;
    reg rstn;
    wire [7:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .en(en),
        .i(i),
        .rstn(rstn),
        .q(q)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Reset behavior", test_num);
        rstn = 0; en = 0; i = 8'hFF;
        #10;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Latch transparent mode (en=1)", test_num);
        rstn = 0; #5; rstn = 1;
        en = 1; i = 8'hAA;
        #10;
        #1;

        check_outputs(8'hAA);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Latch hold mode (en: 1 -> 0)", test_num);
        rstn = 0; #5; rstn = 1;
        en = 1; i = 8'h55;
        #10;
        en = 0;
        #5;
        i = 8'hFF;
        #10;
        #1;

        check_outputs(8'h55);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Reset priority over enable", test_num);
        rstn = 0; #5; rstn = 1;
        en = 1; i = 8'h12;
        #10;
        rstn = 0;
        #10;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Multiple data changes while en=1", test_num);
        rstn = 0; #5; rstn = 1;
        en = 1; i = 8'h01; #10;
        i = 8'h02; #10;
        i = 8'h04; #10;
        i = 8'h08; #10;
        #1;

        check_outputs(8'h08);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Verification of hold after reset", test_num);
        rstn = 0; #5;
        rstn = 1; en = 0; i = 8'hFF;
        #10;

        #1;


        check_outputs(8'h00);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Boundary value 0xFF", test_num);
        rstn = 0; #5; rstn = 1;
        en = 1; i = 8'hFF;
        #10;
        #1;

        check_outputs(8'hFF);
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
        input [7:0] expected_q;
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
