`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] DMout;
    reg [31:0] WD_M;
    reg [1:0] WD_M_sel;
    wire [31:0] WD_W;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .DMout(DMout),
        .WD_M(WD_M),
        .WD_M_sel(WD_M_sel),
        .WD_W(WD_W)
    );
    task testcase001;

    begin
        test_num = 1;
        WD_M = 32'hAAAAAAAA;
        DMout = 32'h55555555;
        WD_M_sel = 2'b00;
        $display("Testcase %0d: Select WD_M (sel=0)", test_num);
        #1;

        check_outputs(32'hAAAAAAAA);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        WD_M = 32'hAAAAAAAA;
        DMout = 32'h55555555;
        WD_M_sel = 2'b01;
        $display("Testcase %0d: Select DMout (sel=1)", test_num);
        #1;

        check_outputs(32'h55555555);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        WD_M = 32'h12345678;
        DMout = 32'h87654321;
        WD_M_sel = 2'b10;
        $display("Testcase %0d: Select DMout (sel=2)", test_num);
        #1;

        check_outputs(32'h87654321);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        WD_M = 32'hFFFFFFFF;
        DMout = 32'h00000000;
        WD_M_sel = 2'b11;
        $display("Testcase %0d: Select DMout (sel=3)", test_num);
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        WD_M = 32'hDEADBEEF;
        DMout = 32'hCAFEBABE;
        WD_M_sel = 2'b00;
        $display("Testcase %0d: Select WD_M (sel=0) with different data", test_num);
        #1;

        check_outputs(32'hDEADBEEF);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        WD_M = 32'h00000000;
        DMout = 32'hFFFFFFFF;
        WD_M_sel = 2'b10;
        $display("Testcase %0d: Select DMout (sel=2) all bits high", test_num);
        #1;

        check_outputs(32'hFFFFFFFF);
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
        input [31:0] expected_WD_W;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_WD_W === (expected_WD_W ^ WD_W ^ expected_WD_W)) begin
                $display("PASS");
                $display("  Outputs: WD_W=%h",
                         WD_W);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: WD_W=%h",
                         expected_WD_W);
                $display("  Got:      WD_W=%h",
                         WD_W);
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
