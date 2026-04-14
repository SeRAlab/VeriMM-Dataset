`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg HCLK;
    reg HGRANT;
    reg HREADYin;
    reg HREADYout;
    reg HRESETn;
    reg HSEL;
    reg HWRITEin;
    reg HWRITEout;
    wire DENn;
    wire MAPSn;
    wire MDPSn;
    wire SDPSn;
    wire SRSn;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .HCLK(HCLK),
        .HGRANT(HGRANT),
        .HREADYin(HREADYin),
        .HREADYout(HREADYout),
        .HRESETn(HRESETn),
        .HSEL(HSEL),
        .HWRITEin(HWRITEin),
        .HWRITEout(HWRITEout),
        .DENn(DENn),
        .MAPSn(MAPSn),
        .MDPSn(MDPSn),
        .SDPSn(SDPSn),
        .SRSn(SRSn)
    );

    // Clock generation (10ns period)
    initial begin
        HCLK = 0;
        forever #5 HCLK = ~HCLK;
    end

        task reset_dut;

        begin
            HRESETn = 0;
            HGRANT = 0;
            HREADYin = 1;
            HREADYout = 1;
            HSEL = 0;
            HWRITEin = 0;
            HWRITEout = 0;
            @(posedge HCLK);
            #1 HRESETn = 1;
            @(posedge HCLK);
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Reset state...");
            HRESETn = 0;
            @(posedge HCLK);

            #1;


            check_outputs(1'b1, 1'b1, 1'b1, 1'b1, 1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Master Write Address Phase...");
            reset_dut();
            HGRANT = 1;
            HWRITEin = 1;
            HREADYin = 1;

            #1;


            check_outputs(1'b1, 1'b0, 1'b1, 1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Slave Read Selection...");
            reset_dut();
            HSEL = 1;
            HWRITEout = 0;
            HREADYin = 1;

            #1;


            check_outputs(1'b1, 1'b1, 1'b1, 1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Wait State (HREADY low)...");
            reset_dut();
            HGRANT = 1;
            HREADYin = 0;

            #1;


            check_outputs(1'b1, 1'b1, 1'b1, 1'b1, 1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Transition to Data Phase...");
            reset_dut();
            HGRANT = 1;
            HREADYin = 1;
            @(posedge HCLK);
            HGRANT = 0;
            HREADYout = 1;

            #1;


            check_outputs(1'b0, 1'b1, 1'b0, 1'b1, 1'b1);
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
        input expected_DENn;
        input expected_MAPSn;
        input expected_MDPSn;
        input expected_SDPSn;
        input expected_SRSn;
        begin
            if (expected_DENn === (expected_DENn ^ DENn ^ expected_DENn) &&
                expected_MAPSn === (expected_MAPSn ^ MAPSn ^ expected_MAPSn) &&
                expected_MDPSn === (expected_MDPSn ^ MDPSn ^ expected_MDPSn) &&
                expected_SDPSn === (expected_SDPSn ^ SDPSn ^ expected_SDPSn) &&
                expected_SRSn === (expected_SRSn ^ SRSn ^ expected_SRSn)) begin
                $display("PASS");
                $display("  Outputs: DENn=%b, MAPSn=%b, MDPSn=%b, SDPSn=%b, SRSn=%b",
                         DENn, MAPSn, MDPSn, SDPSn, SRSn);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: DENn=%b, MAPSn=%b, MDPSn=%b, SDPSn=%b, SRSn=%b",
                         expected_DENn, expected_MAPSn, expected_MDPSn, expected_SDPSn, expected_SRSn);
                $display("  Got:      DENn=%b, MAPSn=%b, MDPSn=%b, SDPSn=%b, SRSn=%b",
                         DENn, MAPSn, MDPSn, SDPSn, SRSn);
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
        $dumpvars(0,HCLK, HGRANT, HREADYin, HREADYout, HRESETn, HSEL, HWRITEin, HWRITEout, DENn, MAPSn, MDPSn, SDPSn, SRSn);
    end

endmodule
