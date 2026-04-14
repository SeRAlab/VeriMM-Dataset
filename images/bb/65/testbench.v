`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
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

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            SCE = 1'b1;
            GATE = 1'b0;
            VPWR = 1'b1;
            VGND = 1'b0;
            VPB = 1'b1;
            VNB = 1'b0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: SCE=0, GATE=1 (Active Inverted Clock)", test_num);
            reset_dut();


            SCE = 1'b0;
            GATE = 1'b1;



            @(negedge CLK);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: SCE=0, GATE=1, checking GCLK=0 when CLK=1", test_num);
            reset_dut();

            SCE = 1'b0;
            GATE = 1'b1;



            @(posedge CLK);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: SCE=0, GATE=0 (Gating by GATE)", test_num);
            reset_dut();

            SCE = 1'b0;
            GATE = 1'b0;


            repeat(2) @(posedge CLK);
            #2;


            #1;



            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: SCE=1, GATE=1 (Gating by SCE)", test_num);
            reset_dut();

            SCE = 1'b1;
            GATE = 1'b1;

            repeat(2) @(posedge CLK);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Recovery to Active State", test_num);
            reset_dut();


            SCE = 1'b1;
            GATE = 1'b1;
            #20;


            SCE = 1'b0;
            GATE = 1'b1;


            @(negedge CLK);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Dynamic GATE change during CLK high", test_num);
            reset_dut();

            SCE = 1'b0;
            GATE = 1'b1;

            @(posedge CLK);
            #2;
            GATE = 1'b0;
            #2;


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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,CLK, GATE, SCE, VGND, VNB, VPB, VPWR, GCLK);
    end

endmodule
