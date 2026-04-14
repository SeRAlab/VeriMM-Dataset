`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg Clock;
    reg [1:0] WB;
    reg [31:0] dataMEM;
    reg [4:0] registradorDestinoData;
    reg [31:0] saidaALU;
    wire [1:0] regWB;
    wire [31:0] saidaALUwb;
    wire [4:0] saidaDestinoData;
    wire [31:0] saidaMEM;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Clock(Clock),
        .WB(WB),
        .dataMEM(dataMEM),
        .registradorDestinoData(registradorDestinoData),
        .saidaALU(saidaALU),
        .regWB(regWB),
        .saidaALUwb(saidaALUwb),
        .saidaDestinoData(saidaDestinoData),
        .saidaMEM(saidaMEM)
    );

    // Clock generation (10ns period)
    initial begin
        Clock = 0;
        forever #5 Clock = ~Clock;
    end

        task reset_dut;

    begin



        WB = 2'b0;
        dataMEM = 32'h0;
        registradorDestinoData = 5'h0;
        saidaALU = 32'h0;
        @(posedge Clock);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Basic Capture - Pattern A", test_num);
        reset_dut();


        WB = 2'b10;
        dataMEM = 32'hABCD_1234;
        registradorDestinoData = 5'h0A;
        saidaALU = 32'h5555_AAAA;


        @(posedge Clock);
        #2;


        #1;



        check_outputs(2'b10, 32'h5555_AAAA, 5'h0A, 32'hABCD_1234);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Basic Capture - Pattern B", test_num);
        reset_dut();

        WB = 2'b01;
        dataMEM = 32'hDEAD_BEEF;
        registradorDestinoData = 5'h1F;
        saidaALU = 32'hCAFE_BABE;

        @(posedge Clock);
        #2;

        #1;


        check_outputs(2'b01, 32'hCAFE_BABE, 5'h1F, 32'hDEAD_BEEF);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: All Zeros Boundary", test_num);
        reset_dut();

        WB = 2'b00;
        dataMEM = 32'h0000_0000;
        registradorDestinoData = 5'h00;
        saidaALU = 32'h0000_0000;

        @(posedge Clock);
        #2;

        #1;


        check_outputs(2'b00, 32'h0000_0000, 5'h00, 32'h0000_0000);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: All Ones Boundary", test_num);
        reset_dut();

        WB = 2'b11;
        dataMEM = 32'hFFFF_FFFF;
        registradorDestinoData = 5'h1F;
        saidaALU = 32'hFFFF_FFFF;

        @(posedge Clock);
        #2;

        #1;


        check_outputs(2'b11, 32'hFFFF_FFFF, 5'h1F, 32'hFFFF_FFFF);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Verify Rising Edge Stability", test_num);
        reset_dut();


        WB = 2'b11;
        dataMEM = 32'h1111_2222;
        registradorDestinoData = 5'd15;
        saidaALU = 32'h3333_4444;


        @(posedge Clock);
        #1;


        WB = 2'b00;
        dataMEM = 32'h0;
        registradorDestinoData = 5'h0;
        saidaALU = 32'h0;

        #2;
        #1;

        check_outputs(2'b11, 32'h3333_4444, 5'd15, 32'h1111_2222);
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
        input [1:0] expected_regWB;
        input [31:0] expected_saidaALUwb;
        input [4:0] expected_saidaDestinoData;
        input [31:0] expected_saidaMEM;
        begin
            if (expected_regWB === (expected_regWB ^ regWB ^ expected_regWB) &&
                expected_saidaALUwb === (expected_saidaALUwb ^ saidaALUwb ^ expected_saidaALUwb) &&
                expected_saidaDestinoData === (expected_saidaDestinoData ^ saidaDestinoData ^ expected_saidaDestinoData) &&
                expected_saidaMEM === (expected_saidaMEM ^ saidaMEM ^ expected_saidaMEM)) begin
                $display("PASS");
                $display("  Outputs: regWB=%h, saidaALUwb=%h, saidaDestinoData=%h, saidaMEM=%h",
                         regWB, saidaALUwb, saidaDestinoData, saidaMEM);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: regWB=%h, saidaALUwb=%h, saidaDestinoData=%h, saidaMEM=%h",
                         expected_regWB, expected_saidaALUwb, expected_saidaDestinoData, expected_saidaMEM);
                $display("  Got:      regWB=%h, saidaALUwb=%h, saidaDestinoData=%h, saidaMEM=%h",
                         regWB, saidaALUwb, saidaDestinoData, saidaMEM);
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
        $dumpvars(0,Clock, WB, dataMEM, registradorDestinoData, saidaALU, regWB, saidaALUwb, saidaDestinoData, saidaMEM);
    end

endmodule
