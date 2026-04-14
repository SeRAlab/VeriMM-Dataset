`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [5:0] ADDRA;
    reg [5:0] ADDRB;
    reg [5:0] ADDRC;
    reg [5:0] ADDRD;
    reg [5:0] ADDRE;
    reg [5:0] ADDRF;
    reg [5:0] ADDRG;
    reg [5:0] ADDRH;
    reg DIA;
    reg DIB;
    reg DIC;
    reg DID;
    reg DIE;
    reg DIF;
    reg DIG;
    reg DIH;
    reg WCLK;
    reg WE;
    wire DOA;
    wire DOB;
    wire DOC;
    wire DOD;
    wire DOE;
    wire DOF;
    wire DOG;
    wire DOH;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ADDRA(ADDRA),
        .ADDRB(ADDRB),
        .ADDRC(ADDRC),
        .ADDRD(ADDRD),
        .ADDRE(ADDRE),
        .ADDRF(ADDRF),
        .ADDRG(ADDRG),
        .ADDRH(ADDRH),
        .DIA(DIA),
        .DIB(DIB),
        .DIC(DIC),
        .DID(DID),
        .DIE(DIE),
        .DIF(DIF),
        .DIG(DIG),
        .DIH(DIH),
        .WCLK(WCLK),
        .WE(WE),
        .DOA(DOA),
        .DOB(DOB),
        .DOC(DOC),
        .DOD(DOD),
        .DOE(DOE),
        .DOF(DOF),
        .DOG(DOG),
        .DOH(DOH)
    );

        task reset_dut;

        begin
            ADDRA = 6'd0; ADDRB = 6'd0; ADDRC = 6'd0; ADDRD = 6'd0;
            ADDRE = 6'd0; ADDRF = 6'd0; ADDRG = 6'd0; ADDRH = 6'd0;
            DIA = 1'b0; DIB = 1'b0; DIC = 1'b0; DID = 1'b0;
            DIE = 1'b0; DIF = 1'b0; DIG = 1'b0; DIH = 1'b0;
            WE = 1'b0;
            WCLK = 1'b0;
            #20;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Basic Write and Read at Address 0");
            test_num = 1;
            reset_dut();


            WE = 1'b1;
            ADDRA = 6'd0; ADDRB = 6'd0; ADDRC = 6'd0; ADDRD = 6'd0;
            ADDRE = 6'd0; ADDRF = 6'd0; ADDRG = 6'd0; ADDRH = 6'd0;
            DIA = 1'b1; DIB = 1'b1; DIC = 1'b1; DID = 1'b1;
            DIE = 1'b1; DIF = 1'b1; DIG = 1'b1; DIH = 1'b1;


            #10 WCLK = 1'b1;
            #10 WCLK = 1'b0;
            WE = 1'b0;
            #10;


            #1;



            check_outputs(1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Write 0s to Address 63");
            test_num = 2;
            reset_dut();


            WE = 1'b1;
            ADDRA = 6'd63; ADDRB = 6'd63; ADDRC = 6'd63; ADDRD = 6'd63;
            ADDRE = 6'd63; ADDRF = 6'd63; ADDRG = 6'd63; ADDRH = 6'd63;
            DIA = 1'b1; DIB = 1'b1; DIC = 1'b1; DID = 1'b1;
            DIE = 1'b1; DIF = 1'b1; DIG = 1'b1; DIH = 1'b1;
            #10 WCLK = 1'b1; #10 WCLK = 1'b0;


            DIA = 1'b0; DIB = 1'b0; DIC = 1'b0; DID = 1'b0;
            DIE = 1'b0; DIF = 1'b0; DIG = 1'b0; DIH = 1'b0;
            #10 WCLK = 1'b1; #10 WCLK = 1'b0;
            WE = 1'b0;
            #10;

            #1;


            check_outputs(1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Multi-address unique pattern");
            test_num = 3;
            reset_dut();

            WE = 1'b1;
            ADDRA=6'd1; ADDRB=6'd2; ADDRC=6'd3; ADDRD=6'd4;
            ADDRE=6'd5; ADDRF=6'd6; ADDRG=6'd7; ADDRH=6'd8;
            DIA=1'b1; DIB=1'b0; DIC=1'b1; DID=1'b0;
            DIE=1'b1; DIF=1'b0; DIG=1'b1; DIH=1'b0;

            #10 WCLK = 1'b1; #10 WCLK = 0;
            WE = 1'b0;
            #10;

            #1;


            check_outputs(1'b1, 1'b0, 1'b1, 1'b0, 1'b1, 1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Write Enable check (WE=0)");
            test_num = 4;
            reset_dut();


            WE = 1'b1;
            ADDRA=6'd10; ADDRB=6'd10; ADDRC=6'd10; ADDRD=6'd10;
            ADDRE=6'd10; ADDRF=6'd10; ADDRG=6'd10; ADDRH=6'd10;
            DIA=1'b1; DIB=1'b1; DIC=1'b1; DID=1'b1;
            DIE=1'b1; DIF=1'b1; DIG=1'b1; DIH=1'b1;
            #10 WCLK = 1'b1; #10 WCLK = 1'b0;


            WE = 1'b0;
            DIA=1'b0; DIB=1'b0; DIC=1'b0; DID=1'b0;
            DIE=1'b0; DIF=1'b0; DIG=1'b0; DIH=1'b0;
            #10 WCLK = 1'b1; #10 WCLK = 1'b0;

            #10;

            #1;


            check_outputs(1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Asynchronous Read verification");
            test_num = 5;
            reset_dut();


            WE = 1'b1;
            ADDRA=6'd20; ADDRB=6'd20; ADDRC=6'd20; ADDRD=6'd20;
            ADDRE=6'd20; ADDRF=6'd20; ADDRG=6'd20; ADDRH=6'd20;
            DIA=1'b1; DIB=1'b1; DIC=1'b1; DID=1'b1;
            DIE=1'b1; DIF=1'b1; DIG=1'b1; DIH=1'b1;
            #10 WCLK = 1'b1; #10 WCLK = 1'b0;


            ADDRA=6'd30; ADDRB=6'd30; ADDRC=6'd30; ADDRD=6'd30;
            ADDRE=6'd30; ADDRF=6'd30; ADDRG=6'd30; ADDRH=6'd30;
            DIA=1'b0; DIB=1'b0; DIC=1'b0; DID=1'b0;
            DIE=1'b0; DIF=1'b0; DIG=1'b0; DIH=1'b0;
            #10 WCLK = 1'b1; #10 WCLK = 1'b0;

            WE = 1'b0;


            ADDRA=6'd20; ADDRB=6'd20; ADDRC=6'd20; ADDRD=6'd20;
            ADDRE=6'd20; ADDRF=6'd20; ADDRG=6'd20; ADDRH=6'd20;
            #10;
            #1;

            check_outputs(1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1);
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
        input expected_DOA;
        input expected_DOB;
        input expected_DOC;
        input expected_DOD;
        input expected_DOE;
        input expected_DOF;
        input expected_DOG;
        input expected_DOH;
        begin
            if (expected_DOA === (expected_DOA ^ DOA ^ expected_DOA) &&
                expected_DOB === (expected_DOB ^ DOB ^ expected_DOB) &&
                expected_DOC === (expected_DOC ^ DOC ^ expected_DOC) &&
                expected_DOD === (expected_DOD ^ DOD ^ expected_DOD) &&
                expected_DOE === (expected_DOE ^ DOE ^ expected_DOE) &&
                expected_DOF === (expected_DOF ^ DOF ^ expected_DOF) &&
                expected_DOG === (expected_DOG ^ DOG ^ expected_DOG) &&
                expected_DOH === (expected_DOH ^ DOH ^ expected_DOH)) begin
                $display("PASS");
                $display("  Outputs: DOA=%b, DOB=%b, DOC=%b, DOD=%b, DOE=%b, DOF=%b, DOG=%b, DOH=%b",
                         DOA, DOB, DOC, DOD, DOE, DOF, DOG, DOH);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: DOA=%b, DOB=%b, DOC=%b, DOD=%b, DOE=%b, DOF=%b, DOG=%b, DOH=%b",
                         expected_DOA, expected_DOB, expected_DOC, expected_DOD, expected_DOE, expected_DOF, expected_DOG, expected_DOH);
                $display("  Got:      DOA=%b, DOB=%b, DOC=%b, DOD=%b, DOE=%b, DOF=%b, DOG=%b, DOH=%b",
                         DOA, DOB, DOC, DOD, DOE, DOF, DOG, DOH);
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
        $dumpvars(0,ADDRA, ADDRB, ADDRC, ADDRD, ADDRE, ADDRF, ADDRG, ADDRH, DIA, DIB, DIC, DID, DIE, DIF, DIG, DIH, WCLK, WE, DOA, DOB, DOC, DOD, DOE, DOF, DOG, DOH);
    end

endmodule
