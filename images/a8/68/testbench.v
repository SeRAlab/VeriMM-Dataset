`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [2:0] DM;
    reg ENABLE_H;
    reg HLD_H_N;
    reg HLD_OVR;
    reg IBUF_SEL;
    reg INP_DIS;
    reg OE_N;
    reg OUT;
    reg REFLEAK_BIAS;
    reg SLOW;
    reg VINREF;
    reg VOUTREF;
    reg VREG_EN;
    reg VTRIP_SEL;
    wire IN;
    wire IN_H;
    wire TIE_LO_ESD;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .DM(DM),
        .ENABLE_H(ENABLE_H),
        .HLD_H_N(HLD_H_N),
        .HLD_OVR(HLD_OVR),
        .IBUF_SEL(IBUF_SEL),
        .INP_DIS(INP_DIS),
        .OE_N(OE_N),
        .OUT(OUT),
        .REFLEAK_BIAS(REFLEAK_BIAS),
        .SLOW(SLOW),
        .VINREF(VINREF),
        .VOUTREF(VOUTREF),
        .VREG_EN(VREG_EN),
        .VTRIP_SEL(VTRIP_SEL),
        .IN(IN),
        .IN_H(IN_H),
        .TIE_LO_ESD(TIE_LO_ESD)
    );

    // Clock generation (10ns period)
    initial begin
        SLOW = 0;
        forever #5 SLOW = ~SLOW;
    end

        task reset_dut;

        begin
            DM = 3'b000;
            ENABLE_H = 1'b0;
            HLD_H_N = 1'b1;
            HLD_OVR = 1'b0;
            IBUF_SEL = 1'b0;
            INP_DIS = 1'b1;
            OE_N = 1'b1;
            OUT = 1'b0;
            REFLEAK_BIAS = 1'b0;
            VINREF = 1'b0;
            VOUTREF = 1'b0;
            VREG_EN = 1'b0;
            VTRIP_SEL = 1'b0;
            drive_pad = 1'b0;
            pad_driver_reg = 1'bz;
            repeat(2) @(posedge SLOW);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            ENABLE_H = 1'b1;
            INP_DIS = 1'b0;
            OE_N = 1'b1;
            drive_pad = 1'b1;
            pad_driver_reg = 1'b1;
            repeat(2) @(posedge SLOW);
            $display("Testcase 001: Input Path High");
            #1;

            check_outputs(1'b1, 1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            ENABLE_H = 1'b1;
            INP_DIS = 1'b0;
            OE_N = 1'b1;
            drive_pad = 1'b1;
            pad_driver_reg = 1'b0;
            repeat(2) @(posedge SLOW);
            $display("Testcase 002: Input Path Low");
            #1;

            check_outputs(1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            ENABLE_H = 1'b1;
            INP_DIS = 1'b1;
            OE_N = 1'b1;
            drive_pad = 1'b1;
            pad_driver_reg = 1'b1;
            repeat(2) @(posedge SLOW);
            $display("Testcase 003: Input Disable Check");

            #1;


            check_outputs(1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            ENABLE_H = 1'b1;
            INP_DIS = 1'b0;
            drive_pad = 1'b1;
            pad_driver_reg = 1'b1;
            @(posedge SLOW);
            HLD_H_N = 1'b0;
            @(posedge SLOW);
            pad_driver_reg = 1'b0;
            repeat(2) @(posedge SLOW);
            $display("Testcase 004: Hold Mechanism Active");

            #1;


            check_outputs(1'b1, 1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            ENABLE_H = 1'b1;
            OE_N = 1'b0;
            OUT = 1'b1;
            drive_pad = 1'b0;
            repeat(2) @(posedge SLOW);
            $display("Testcase 005: Output Drive High Loopback");

            #1;


            check_outputs(1'b1, 1'b1, 1'b0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            ENABLE_H = 1'b1;
            OE_N = 1'b0;
            OUT = 1'b0;
            drive_pad = 1'b0;
            repeat(2) @(posedge SLOW);
            $display("Testcase 006: Output Drive Low Loopback");
            #1;

            check_outputs(1'b0, 1'b0, 1'b0);
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
        input expected_IN;
        input expected_IN_H;
        input expected_TIE_LO_ESD;
        begin
            if (expected_IN === (expected_IN ^ IN ^ expected_IN) &&
                expected_IN_H === (expected_IN_H ^ IN_H ^ expected_IN_H) &&
                expected_TIE_LO_ESD === (expected_TIE_LO_ESD ^ TIE_LO_ESD ^ expected_TIE_LO_ESD)) begin
                $display("PASS");
                $display("  Outputs: IN=%b, IN_H=%b, TIE_LO_ESD=%b",
                         IN, IN_H, TIE_LO_ESD);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: IN=%b, IN_H=%b, TIE_LO_ESD=%b",
                         expected_IN, expected_IN_H, expected_TIE_LO_ESD);
                $display("  Got:      IN=%b, IN_H=%b, TIE_LO_ESD=%b",
                         IN, IN_H, TIE_LO_ESD);
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
        $dumpvars(0,DM, ENABLE_H, HLD_H_N, HLD_OVR, IBUF_SEL, INP_DIS, OE_N, OUT, REFLEAK_BIAS, SLOW, VINREF, VOUTREF, VREG_EN, VTRIP_SEL, IN, IN_H, TIE_LO_ESD);
    end

endmodule
