`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [4:0] ADDRA;
    reg [4:0] ADDRB;
    reg [4:0] ADDRC;
    reg [4:0] ADDRD;
    reg [4:0] ADDRE;
    reg [4:0] ADDRF;
    reg [4:0] ADDRG;
    reg [4:0] ADDRH;
    reg [1:0] DIA;
    reg [1:0] DIB;
    reg [1:0] DIC;
    reg [1:0] DID;
    reg [1:0] DIE;
    reg [1:0] DIF;
    reg [1:0] DIG;
    reg [1:0] DIH;
    reg WCLK;
    reg WE;
    wire [1:0] DOA;
    wire [1:0] DOB;
    wire [1:0] DOC;
    wire [1:0] DOD;
    wire [1:0] DOE;
    wire [1:0] DOF;
    wire [1:0] DOG;
    wire [1:0] DOH;

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
            WE = 0;
            ADDRA = 0; ADDRB = 0; ADDRC = 0; ADDRD = 0;
            ADDRE = 0; ADDRF = 0; ADDRG = 0; ADDRH = 0;
            DIA = 0; DIB = 0; DIC = 0; DID = 0;
            DIE = 0; DIF = 0; DIG = 0; DIH = 0;
            #20;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Test Case 001: Basic Write and Read at Address 5");

            @(negedge WCLK);
            WE = 1;
            ADDRA = 5; DIA = 2'b00;
            ADDRB = 5; DIB = 2'b01;
            ADDRC = 5; DIC = 2'b10;
            ADDRD = 5; DID = 2'b11;
            ADDRE = 5; DIE = 2'b11;
            ADDRF = 5; DIF = 2'b10;
            ADDRG = 5; DIG = 2'b01;
            ADDRH = 5; DIH = 2'b00;

            @(posedge WCLK);
            #2;
            WE = 0;

            #10;
            #1;

            check_outputs(2'b00, 2'b01, 2'b10, 2'b11, 2'b11, 2'b10, 2'b01, 2'b00);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Test Case 002: Write to Address 31");

            @(negedge WCLK);
            WE = 1;
            ADDRA = 31; DIA = 2'b11;
            ADDRB = 31; DIB = 2'b10;
            ADDRC = 31; DIC = 2'b01;
            ADDRD = 31; DID = 2'b00;
            ADDRE = 31; DIE = 2'b00;
            ADDRF = 31; DIF = 2'b01;
            ADDRG = 31; DIG = 2'b10;
            ADDRH = 31; DIH = 2'b11;

            @(posedge WCLK);
            #2;
            WE = 0;

            #10;
            #1;

            check_outputs(2'b11, 2'b10, 2'b01, 2'b00, 2'b00, 2'b01, 2'b10, 2'b11);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Test Case 003: Verify Write Enable (WE=0)");


            @(negedge WCLK);
            WE = 1;
            ADDRA = 10; DIA = 2'b01;

            @(posedge WCLK);
            #2;


            WE = 0;
            DIA = 2'b11;
            @(posedge WCLK);
            #2;


            #1;



            check_outputs(2'b01, 2'b00, 2'b00, 2'b00, 2'b00, 2'b00, 2'b00, 2'b00);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Test Case 004: Unique Addresses for Each Port");

            @(negedge WCLK);
            WE = 1;
            ADDRA = 1; DIA = 2'b01;
            ADDRB = 2; DIB = 2'b10;
            ADDRC = 3; DIC = 2'b11;
            ADDRD = 4; DID = 2'b00;
            ADDRE = 5; DIE = 2'b01;
            ADDRF = 6; DIF = 2'b10;
            ADDRG = 7; DIG = 2'b11;
            ADDRH = 8; DIH = 2'b00;

            @(posedge WCLK);
            #2;
            WE = 0;

            #10;

            #1;


            check_outputs(2'b01, 2'b10, 2'b11, 2'b00, 2'b01, 2'b10, 2'b11, 2'b00);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Test Case 005: Overwriting Data");

            @(negedge WCLK);
            WE = 1;
            ADDRA = 15; DIA = 2'b11;
            ADDRB = 15; DIB = 2'b11;
            @(posedge WCLK);
            #5;

            DIA = 2'b00;
            DIB = 2'b01;
            @(posedge WCLK);
            #2;
            WE = 0;

            #1;


            check_outputs(2'b00, 2'b01, 2'b00, 2'b00, 2'b00, 2'b00, 2'b00, 2'b00);
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
        input [1:0] expected_DOA;
        input [1:0] expected_DOB;
        input [1:0] expected_DOC;
        input [1:0] expected_DOD;
        input [1:0] expected_DOE;
        input [1:0] expected_DOF;
        input [1:0] expected_DOG;
        input [1:0] expected_DOH;
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
                $display("  Outputs: DOA=%h, DOB=%h, DOC=%h, DOD=%h, DOE=%h, DOF=%h, DOG=%h, DOH=%h",
                         DOA, DOB, DOC, DOD, DOE, DOF, DOG, DOH);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: DOA=%h, DOB=%h, DOC=%h, DOD=%h, DOE=%h, DOF=%h, DOG=%h, DOH=%h",
                         expected_DOA, expected_DOB, expected_DOC, expected_DOD, expected_DOE, expected_DOF, expected_DOG, expected_DOH);
                $display("  Got:      DOA=%h, DOB=%h, DOC=%h, DOD=%h, DOE=%h, DOF=%h, DOG=%h, DOH=%h",
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
