`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK_68KCLK;
    reg PDTACK;
    reg nAS;
    reg nCARD_ZONE;
    reg nPORT_ZONE;
    reg nPWAIT0;
    reg nPWAIT1;
    reg nROMWAIT;
    reg nROM_ZONE;
    wire nDTACK;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK_68KCLK(CLK_68KCLK),
        .PDTACK(PDTACK),
        .nAS(nAS),
        .nCARD_ZONE(nCARD_ZONE),
        .nPORT_ZONE(nPORT_ZONE),
        .nPWAIT0(nPWAIT0),
        .nPWAIT1(nPWAIT1),
        .nROMWAIT(nROMWAIT),
        .nROM_ZONE(nROM_ZONE),
        .nDTACK(nDTACK)
    );

    // Clock generation (10ns period)
    initial begin
        CLK_68KCLK = 0;
        forever #5 CLK_68KCLK = ~CLK_68KCLK;
    end

        task reset_dut;

        begin
            nAS = 1;
            nROM_ZONE = 1;
            nPORT_ZONE = 1;
            nCARD_ZONE = 1;
            nROMWAIT = 1;
            nPWAIT0 = 1;
            nPWAIT1 = 1;
            PDTACK = 1;
            #20;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Idle State (nAS=1)", test_num);
            reset_dut();
            nROM_ZONE = 0;
            #50;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Card Zone Access (Fastest)", test_num);
            reset_dut();
            nCARD_ZONE = 0;
            @(negedge CLK_68KCLK);
            nAS = 0;
            #100;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: ROM Access (nROMWAIT=1)", test_num);
            reset_dut();
            nROM_ZONE = 0;
            nROMWAIT = 1;
            @(negedge CLK_68KCLK);
            nAS = 0;
            #100;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: ROM Access (nROMWAIT=0)", test_num);
            reset_dut();
            nROM_ZONE = 0;
            nROMWAIT = 0;
            @(negedge CLK_68KCLK);
            nAS = 0;
            #150;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Port Access (nPWAIT=00)", test_num);
            reset_dut();
            nPORT_ZONE = 0;
            nPWAIT1 = 0;
            nPWAIT0 = 0;
            @(negedge CLK_68KCLK);
            nAS = 0;
            #100;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Port Access (nPWAIT=11)", test_num);
            reset_dut();
            nPORT_ZONE = 0;
            nPWAIT1 = 1;
            nPWAIT0 = 1;
            @(negedge CLK_68KCLK);
            nAS = 0;
            #200;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: External PDTACK Trigger", test_num);
            reset_dut();
            nPORT_ZONE = 0;
            nPWAIT1 = 1;
            nPWAIT0 = 1;
            @(negedge CLK_68KCLK);
            nAS = 0;
            #10;
            PDTACK = 0;
            #20;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: No Zone Selected", test_num);
            reset_dut();
            nAS = 0;
            #100;
            #1;

            check_outputs(1'b1);
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
        input expected_nDTACK;
        begin
            if (expected_nDTACK === (expected_nDTACK ^ nDTACK ^ expected_nDTACK)) begin
                $display("PASS");
                $display("  Outputs: nDTACK=%b",
                         nDTACK);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: nDTACK=%b",
                         expected_nDTACK);
                $display("  Got:      nDTACK=%b",
                         nDTACK);
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
        $dumpvars(0,CLK_68KCLK, PDTACK, nAS, nCARD_ZONE, nPORT_ZONE, nPWAIT0, nPWAIT1, nROMWAIT, nROM_ZONE, nDTACK);
    end

endmodule
