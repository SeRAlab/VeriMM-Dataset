`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg [9:0] DMLocationWritingTo;
    reg [11:0] IFFTOutput;
    reg [8:0] IFFTOutputIndex;
    reg IFFTOutputWE;
    reg SampleDelayZero;
    wire DACCS;
    wire [11:0] DACDataInput;
    wire DACLDAC;
    wire DACPD;
    wire DACWE;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .DMLocationWritingTo(DMLocationWritingTo),
        .IFFTOutput(IFFTOutput),
        .IFFTOutputIndex(IFFTOutputIndex),
        .IFFTOutputWE(IFFTOutputWE),
        .SampleDelayZero(SampleDelayZero),
        .DACCS(DACCS),
        .DACDataInput(DACDataInput),
        .DACLDAC(DACLDAC),
        .DACPD(DACPD),
        .DACWE(DACWE)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            DMLocationWritingTo = 10'd0;
            IFFTOutput = 12'd0;
            IFFTOutputIndex = 9'd0;
            IFFTOutputWE = 1'b0;
            SampleDelayZero = 1'b0;
            @(posedge CLK);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Memory Write and Trigger...");
            reset_dut();


            IFFTOutput = 12'hABC;
            IFFTOutputIndex = 9'd5;
            IFFTOutputWE = 1'b1;
            @(posedge CLK);
            IFFTOutputWE = 1'b0;
            @(posedge CLK);


            DMLocationWritingTo = 10'd5;
            SampleDelayZero = 1'b1;
            repeat(2) @(posedge CLK);



            #1;




            check_outputs(1'b0, 12'hABC, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Different Address Write...");
            reset_dut();


            IFFTOutput = 12'h555;
            IFFTOutputIndex = 9'd127;
            IFFTOutputWE = 1'b1;
            @(posedge CLK);
            IFFTOutputWE = 1'b0;
            @(posedge CLK);


            DMLocationWritingTo = 10'd127;
            SampleDelayZero = 1'b1;
            repeat(2) @(posedge CLK);

            #1;


            check_outputs(1'b0, 12'h555, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Idle State Check...");
            reset_dut();


            IFFTOutput = 12'hFFF;
            IFFTOutputIndex = 9'd10;
            IFFTOutputWE = 1'b1;
            @(posedge CLK);
            IFFTOutputWE = 1'b0;

            DMLocationWritingTo = 10'd10;
            SampleDelayZero = 1'b0;
            repeat(5) @(posedge CLK);


            #1;



            check_outputs(1'b1, 12'h000, 1'b1, 1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Overwrite Check...");
            reset_dut();


            IFFTOutput = 12'h111;
            IFFTOutputIndex = 9'd20;
            IFFTOutputWE = 1'b1;
            @(posedge CLK);

            IFFTOutput = 12'h222;
            @(posedge CLK);
            IFFTOutputWE = 1'b0;


            DMLocationWritingTo = 10'd20;
            SampleDelayZero = 1'b1;
            repeat(2) @(posedge CLK);

            #1;


            check_outputs(1'b0, 12'h222, 1'b0, 1'b0, 1'b0);
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
        input expected_DACCS;
        input [11:0] expected_DACDataInput;
        input expected_DACLDAC;
        input expected_DACPD;
        input expected_DACWE;
        begin
            if (expected_DACCS === (expected_DACCS ^ DACCS ^ expected_DACCS) &&
                expected_DACDataInput === (expected_DACDataInput ^ DACDataInput ^ expected_DACDataInput) &&
                expected_DACLDAC === (expected_DACLDAC ^ DACLDAC ^ expected_DACLDAC) &&
                expected_DACPD === (expected_DACPD ^ DACPD ^ expected_DACPD) &&
                expected_DACWE === (expected_DACWE ^ DACWE ^ expected_DACWE)) begin
                $display("PASS");
                $display("  Outputs: DACCS=%b, DACDataInput=%h, DACLDAC=%b, DACPD=%b, DACWE=%b",
                         DACCS, DACDataInput, DACLDAC, DACPD, DACWE);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: DACCS=%b, DACDataInput=%h, DACLDAC=%b, DACPD=%b, DACWE=%b",
                         expected_DACCS, expected_DACDataInput, expected_DACLDAC, expected_DACPD, expected_DACWE);
                $display("  Got:      DACCS=%b, DACDataInput=%h, DACLDAC=%b, DACPD=%b, DACWE=%b",
                         DACCS, DACDataInput, DACLDAC, DACPD, DACWE);
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
        $dumpvars(0,CLK, DMLocationWritingTo, IFFTOutput, IFFTOutputIndex, IFFTOutputWE, SampleDelayZero, DACCS, DACDataInput, DACLDAC, DACPD, DACWE);
    end

endmodule
