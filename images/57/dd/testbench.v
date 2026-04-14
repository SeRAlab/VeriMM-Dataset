`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg CLK;
    reg GATE;
    reg SCE;
    reg VGND;
    reg VNB;
    reg VPB;
    reg VPWR;
    wire GCLK;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .GATE(GATE),
        .SCE(SCE),
        .VGND(VGND),
        .VNB(VNB),
        .VPB(VPB),
        .VPWR(VPWR),
        .GCLK(GCLK)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: All enables low, check GCLK is gated (low)", test_num);

        VPWR = 1; VGND = 0; VPB = 1; VNB = 0;
        SCE = 0; GATE = 0; CLK = 0;
        #10;
        CLK = 1;
        #10;

        #1;


        check_outputs(0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: GATE high, check GCLK follows CLK", test_num);

        SCE = 0; GATE = 0; CLK = 0;
        #10;

        GATE = 1;
        #10;
        CLK = 1;
        #10;

        #1;


        check_outputs(1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: SCE high, check GCLK follows CLK", test_num);

        SCE = 0; GATE = 0; CLK = 0;
        #10;

        SCE = 1;
        #10;
        CLK = 1;
        #10;

        #1;


        check_outputs(1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Both enables high, check GCLK follows CLK", test_num);

        SCE = 0; GATE = 0; CLK = 0;
        #10;

        SCE = 1; GATE = 1;
        #10;
        CLK = 1;
        #10;

        #1;


        check_outputs(1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Disable enables, check GCLK returns to 0", test_num);

        SCE = 1; GATE = 1; CLK = 1;
        #10;

        CLK = 0;
        SCE = 0;
        GATE = 0;
        #10;

        CLK = 1;
        #10;

        #1;


        check_outputs(0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Check GCLK low when CLK is low even if enabled", test_num);

        SCE = 1; GATE = 0;
        CLK = 0;
        #10;

        #1;


        check_outputs(0);
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
        input expected_GCLK;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_GCLK === (expected_GCLK ^ GCLK ^ expected_GCLK)) begin
                $display("PASS");
                $display("  Outputs: GCLK=%b",
                         GCLK);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: GCLK=%b",
                         expected_GCLK);
                $display("  Got:      GCLK=%b",
                         GCLK);
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
