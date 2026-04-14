`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] ADDRA;
    reg [7:0] ADDRB;
    reg CLKA;
    reg CLKB;
    reg [15:0] DIA;
    reg [15:0] DIB;
    reg ENA;
    reg ENB;
    reg RSTA;
    reg RSTB;
    reg WEA;
    reg WEB;
    wire [15:0] DOA;
    wire [15:0] DOB;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ADDRA(ADDRA),
        .ADDRB(ADDRB),
        .CLKA(CLKA),
        .CLKB(CLKB),
        .DIA(DIA),
        .DIB(DIB),
        .ENA(ENA),
        .ENB(ENB),
        .RSTA(RSTA),
        .RSTB(RSTB),
        .WEA(WEA),
        .WEB(WEB),
        .DOA(DOA),
        .DOB(DOB)
    );

    // Clock generation (10ns period)
    initial begin
        CLKA = 0;
        forever #5 CLKA = ~CLKA;
    end

        task reset_dut;

        begin
            RSTA = 1; RSTB = 1;
            ENA = 0;  ENB = 0;
            WEA = 0;  WEB = 0;
            ADDRA = 0; ADDRB = 0;
            DIA = 0;  DIB = 0;
            repeat (2) @(posedge CLKA);
            RSTA = 0; RSTB = 0;
            @(posedge CLKA);
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Port A Write/Read...");
            reset_dut();

            @(negedge CLKA);
            ADDRA = 8'h10; DIA = 16'hABCD; ENA = 1; WEA = 1;
            @(negedge CLKA);
            WEA = 0;

            ADDRA = 8'h10;
            @(posedge CLKA);
            #1;
            #1;

            check_outputs(16'hABCD, 16'hxxxx);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Port B Write/Read...");
            reset_dut();

            @(negedge CLKB);
            ADDRB = 8'h20; DIB = 16'h1234; ENB = 1; WEB = 1;
            @(negedge CLKB);
            WEB = 0;

            ADDRB = 8'h20;
            @(posedge CLKB);
            #1;
            #1;

            check_outputs(16'hxxxx, 16'h1234);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Cross-port Write A, Read B...");
            reset_dut();

            @(negedge CLKA);
            ADDRA = 8'h55; DIA = 16'h55AA; ENA = 1; WEA = 1;
            @(negedge CLKA);
            WEA = 0; ENA = 0;

            @(negedge CLKB);
            ADDRB = 8'h55; ENB = 1; WEB = 0;
            @(posedge CLKB);
            #1;
            #1;

            check_outputs(16'hxxxx, 16'h55AA);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Dual Port Simultaneous Write...");
            reset_dut();
            @(negedge CLKA);
            ADDRA = 8'h01; DIA = 16'hAAAA; ENA = 1; WEA = 1;
            ADDRB = 8'h02; DIB = 16'hBBBB; ENB = 1; WEB = 1;
            @(negedge CLKA);
            WEA = 0; WEB = 0;

            ADDRA = 8'h01; ADDRB = 8'h02;
            @(posedge CLKA);
            #1;
            #1;

            check_outputs(16'hAAAA, 16'hBBBB);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Write Enable Check...");
            reset_dut();

            @(negedge CLKA);
            ADDRA = 8'hA0; DIA = 16'hFFFF; ENA = 1; WEA = 0;
            @(negedge CLKA);

            ADDRA = 8'hA0;
            @(posedge CLKA);
            #1;

            if (DOA === 16'hFFFF) begin
                $display("FAIL: Data written while WE was low");
                fail_count = fail_count + 1;
            end else begin
                $display("PASS: Data was not written while WE was low");
                pass_count = pass_count + 1;
            end
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: Port Enable Check...");
            reset_dut();

            @(negedge CLKA);
            ADDRA = 8'h77; DIA = 16'h7777; ENA = 1; WEA = 1;
            @(negedge CLKA);
            WEA = 0; ENA = 0;
            ADDRA = 8'h77;
            @(posedge CLKA);
            #1;

            if (DOA === 16'h7777) begin
                $display("FAIL: Port A output updated while ENA was low");
                fail_count = fail_count + 1;
            end else begin
                $display("PASS: Port A respected Enable signal");
                pass_count = pass_count + 1;
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
        input [15:0] expected_DOA;
        input [15:0] expected_DOB;
        begin
            if (expected_DOA === (expected_DOA ^ DOA ^ expected_DOA) &&
                expected_DOB === (expected_DOB ^ DOB ^ expected_DOB)) begin
                $display("PASS");
                $display("  Outputs: DOA=%h, DOB=%h",
                         DOA, DOB);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: DOA=%h, DOB=%h",
                         expected_DOA, expected_DOB);
                $display("  Got:      DOA=%h, DOB=%h",
                         DOA, DOB);
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
        $dumpvars(0,ADDRA, ADDRB, CLKA, CLKB, DIA, DIB, ENA, ENB, RSTA, RSTB, WEA, WEB, DOA, DOB);
    end

endmodule
