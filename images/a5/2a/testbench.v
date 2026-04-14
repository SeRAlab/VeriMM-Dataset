`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [17:0] ADDRARDADDR;
    reg [17:0] ADDRBWRADDR;
    reg CLKARDCLK;
    reg CLKBWRCLK;
    reg [17:0] DIADI;
    reg [17:0] DIBDI;
    reg ENARDEN;
    reg ENBWREN;
    reg WEA;
    reg WEBWE;
    wire [17:0] DOADO;
    wire [17:0] DOBDO;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ADDRARDADDR(ADDRARDADDR),
        .ADDRBWRADDR(ADDRBWRADDR),
        .CLKARDCLK(CLKARDCLK),
        .CLKBWRCLK(CLKBWRCLK),
        .DIADI(DIADI),
        .DIBDI(DIBDI),
        .ENARDEN(ENARDEN),
        .ENBWREN(ENBWREN),
        .WEA(WEA),
        .WEBWE(WEBWE),
        .DOADO(DOADO),
        .DOBDO(DOBDO)
    );

    // Clock generation (10ns period)
    initial begin
        CLKARDCLK = 0;
        forever #5 CLKARDCLK = ~CLKARDCLK;
    end

        task reset_dut;

        begin
            ADDRARDADDR = 0;
            ADDRBWRADDR = 0;
            DIADI = 0;
            DIBDI = 0;
            ENARDEN = 0;
            ENBWREN = 0;
            WEA = 0;
            WEBWE = 0;
            @(posedge CLKARDCLK);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Port A Basic Write/Read");
            reset_dut();


            ADDRARDADDR = 18'h00001;
            DIADI = 18'h12345;
            ENARDEN = 1;
            WEA = 1;
            @(posedge CLKARDCLK);
            #1;


            WEA = 0;
            ADDRARDADDR = 18'h00001;
            @(posedge CLKARDCLK);
            #2;

            #1;


            check_outputs(18'h12345, 18'hzzzzz);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Port B Basic Write/Read");
            reset_dut();


            ADDRBWRADDR = 18'h00002;
            DIBDI = 18'h2ABCD;
            ENBWREN = 1;
            WEBWE = 1;
            @(posedge CLKBWRCLK);
            #1;


            WEBWE = 0;
            ADDRBWRADDR = 18'h00002;
            @(posedge CLKBWRCLK);
            #2;

            #1;


            check_outputs(18'hzzzzz, 18'h2ABCD);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Parallel Writes/Reads");
            reset_dut();


            ENARDEN = 1; WEA = 1; ADDRARDADDR = 18'h10; DIADI = 18'hAAAAA;
            ENBWREN = 1; WEBWE = 1; ADDRBWRADDR = 18'h20; DIBDI = 18'hBBBBB;
            @(posedge CLKARDCLK);
            #1;


            WEA = 0; WEBWE = 0;
            ADDRARDADDR = 18'h10;
            ADDRBWRADDR = 18'h20;
            @(posedge CLKARDCLK);
            #2;

            #1;


            check_outputs(18'hAAAAA, 18'hBBBBB);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Port A Write, Port B Read same address");
            reset_dut();


            ENARDEN = 1; WEA = 1; ADDRARDADDR = 18'hFF; DIADI = 18'h33333;
            @(posedge CLKARDCLK);
            #1;


            WEA = 0;
            ENBWREN = 1; WEBWE = 0; ADDRBWRADDR = 18'hFF;
            @(posedge CLKBWRCLK);
            #2;

            #1;


            check_outputs(18'hzzzzz, 18'h33333);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Enable (EN) behavior check");
            reset_dut();


            ENARDEN = 0; WEA = 1; ADDRARDADDR = 18'h50; DIADI = 18'h55555;
            @(posedge CLKARDCLK);
            #1;


            WEA = 0; ENARDEN = 1; ADDRARDADDR = 18'h50;
            @(posedge CLKARDCLK);
            #2;


            if (DOADO !== 18'h55555) begin
                pass_count = pass_count + 1;
                $display("PASS: Write inhibited while EN=0");
            end else begin
                fail_count = fail_count + 1;
                $display("FAIL: Write occurred while EN=0");
            end
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
        input [17:0] expected_DOADO;
        input [17:0] expected_DOBDO;
        begin
            if (expected_DOADO === (expected_DOADO ^ DOADO ^ expected_DOADO) &&
                expected_DOBDO === (expected_DOBDO ^ DOBDO ^ expected_DOBDO)) begin
                $display("PASS");
                $display("  Outputs: DOADO=%h, DOBDO=%h",
                         DOADO, DOBDO);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: DOADO=%h, DOBDO=%h",
                         expected_DOADO, expected_DOBDO);
                $display("  Got:      DOADO=%h, DOBDO=%h",
                         DOADO, DOBDO);
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
        $dumpvars(0,ADDRARDADDR, ADDRBWRADDR, CLKARDCLK, CLKBWRCLK, DIADI, DIBDI, ENARDEN, ENBWREN, WEA, WEBWE, DOADO, DOBDO);
    end

endmodule
