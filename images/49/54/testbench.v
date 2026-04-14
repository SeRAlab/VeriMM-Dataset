`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK_68KCLKB;
    reg [7:0] D;
    reg [3:0] SDPA;
    reg SDPMPX;
    reg [1:0] SDRA_L;
    reg [3:0] SDRA_U;
    reg SDRMPX;
    reg nSDPOE;
    reg nSDROE;
    wire [23:0] A;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK_68KCLKB(CLK_68KCLKB),
        .D(D),
        .SDPA(SDPA),
        .SDPMPX(SDPMPX),
        .SDRA_L(SDRA_L),
        .SDRA_U(SDRA_U),
        .SDRMPX(SDRMPX),
        .nSDPOE(nSDPOE),
        .nSDROE(nSDROE),
        .A(A)
    );

    // Clock generation (10ns period)
    initial begin
        CLK_68KCLKB = 0;
        forever #5 CLK_68KCLKB = ~CLK_68KCLKB;
    end

        task reset_dut;

        begin
            nSDROE = 1;
            nSDPOE = 1;
            SDRMPX = 0;
            SDPMPX = 0;
            SDRA_L = 2'b00;
            SDRA_U = 4'b0000;
            SDPA   = 4'b0000;
            D      = 8'h00;
            SDRAD_reg = 8'h00;
            SDPAD_reg = 8'h00;
            SDR_en = 0;
            SDP_en = 0;
            repeat(2) @(posedge CLK_68KCLKB);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase 001: Latching SDRAD to RALATCH");

            SDRA_U = 4'hA;
            SDPA   = 4'hB;


            SDR_en = 1;
            SDRAD_reg = 8'h34;
            nSDROE = 0;
            @(posedge CLK_68KCLKB);
            #2;
            nSDROE = 1;
            SDR_en = 0;



            #1;




            check_outputs(24'hA00B34);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase 002: Latching SDPAD to PALATCH");

            SDP_en = 1;
            SDPAD_reg = 8'hFE;
            nSDPOE = 0;
            @(posedge CLK_68KCLKB);
            #2;
            nSDPOE = 1;
            SDP_en = 0;


            #1;



            check_outputs(24'h0FE000);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase 003: Full Address Construction");

            SDRA_U = 4'hF;
            SDPA   = 4'h5;


            SDR_en = 1; SDRAD_reg = 8'h22; nSDROE = 0;
            @(posedge CLK_68KCLKB); #1 nSDROE = 1; SDR_en = 0;


            SDP_en = 1; SDPAD_reg = 8'h88; nSDPOE = 0;
            @(posedge CLK_68KCLKB); #1 nSDPOE = 1; SDP_en = 0;


            #1;



            check_outputs(24'hF88522);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase 004: Multiplexer Control Check");

            SDRA_U = 4'h1;
            SDRMPX = 1;



            #1;




            check_outputs(A);
            pass_count = pass_count + 1;
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
        input [23:0] expected_A;
        begin
            if (expected_A === (expected_A ^ A ^ expected_A)) begin
                $display("PASS");
                $display("  Outputs: A=%h",
                         A);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: A=%h",
                         expected_A);
                $display("  Got:      A=%h",
                         A);
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
        $dumpvars(0,CLK_68KCLKB, D, SDPA, SDPMPX, SDRA_L, SDRA_U, SDRMPX, nSDPOE, nSDROE, A);
    end

endmodule
