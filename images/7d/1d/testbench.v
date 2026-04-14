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
    wire DOA;
    wire DOB;
    wire DOC;
    wire DOD;
    wire DOE;
    wire DOF;
    wire DOG;
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
            ADDRA = 0; ADDRB = 0; ADDRC = 0; ADDRD = 0;
            ADDRE = 0; ADDRF = 0; ADDRG = 0; ADDRH = 0;
            DIA = 0; DIB = 0; DIC = 0; DID = 0;
            DIE = 0; DIF = 0; DIG = 0; DIH = 0;
            WE = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase %0d: Write 0xFFFF to Address 1", test_num);
            @(posedge WCLK);
            WE = 1;
            ADDRH = 5'd1;
            DIA = 2'b11; DIB = 2'b11; DIC = 2'b11; DID = 2'b11;
            DIE = 2'b11; DIF = 2'b11; DIG = 2'b11; DIH = 2'b11;
            @(posedge WCLK);
            #1;
            WE = 0;
            ADDRA = 6'd1; ADDRB = 6'd1; ADDRC = 6'd1; ADDRD = 6'd1;
            ADDRE = 6'd1; ADDRF = 6'd1; ADDRG = 6'd1; ADDRH = 5'd1;
            #1;
            #1;

            check_outputs(1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 2'b11);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase %0d: Write 0x0000 to Address 1", test_num);
            @(posedge WCLK);
            WE = 1;
            ADDRH = 5'd1;
            DIA = 2'b00; DIB = 2'b00; DIC = 2'b00; DID = 2'b00;
            DIE = 2'b00; DIF = 2'b00; DIG = 2'b00; DIH = 2'b00;
            @(posedge WCLK);
            #1;
            WE = 0;
            ADDRA = 6'd1; ADDRB = 6'd1; ADDRC = 6'd1; ADDRD = 6'd1;
            ADDRE = 6'd1; ADDRF = 6'd1; ADDRG = 6'd1; ADDRH = 5'd1;
            #1;
            #1;

            check_outputs(1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 2'b00);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase %0d: Write 0xAAAA to Address 5", test_num);
            @(posedge WCLK);
            WE = 1;
            ADDRH = 5'd5;
            DIA = 2'b10; DIB = 2'b10; DIC = 2'b10; DID = 2'b10;
            DIE = 2'b10; DIF = 2'b10; DIG = 2'b10; DIH = 2'b10;
            @(posedge WCLK);
            #1;
            WE = 0;
            ADDRA = 6'd5; ADDRB = 6'd5; ADDRC = 6'd5; ADDRD = 6'd5;
            ADDRE = 6'd5; ADDRF = 6'd5; ADDRG = 6'd5; ADDRH = 5'd5;
            #1;
            #1;

            check_outputs(1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 2'b10);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase %0d: Write 0x5555 to Address 10", test_num);
            @(posedge WCLK);
            WE = 1;
            ADDRH = 5'd10;
            DIA = 2'b01; DIB = 2'b01; DIC = 2'b01; DID = 2'b01;
            DIE = 2'b01; DIF = 2'b01; DIG = 2'b01; DIH = 2'b01;
            @(posedge WCLK);
            #1;
            WE = 0;
            ADDRA = 6'd10; ADDRB = 6'd10; ADDRC = 6'd10; ADDRD = 6'd10;
            ADDRE = 6'd10; ADDRF = 6'd10; ADDRG = 6'd10; ADDRH = 5'd10;
            #1;
            #1;

            check_outputs(1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 2'b01);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase %0d: Independent Port Address Read", test_num);
            @(posedge WCLK);
            WE = 1; ADDRH = 5'd20;
            DIA = 2'b11; DIB = 2'b11; DIC = 2'b11; DID = 2'b11;
            DIE = 2'b11; DIF = 2'b11; DIG = 2'b11; DIH = 2'b11;
            @(posedge WCLK);
            WE = 1; ADDRH = 5'd21;
            DIA = 2'b00; DIB = 2'b00; DIC = 2'b00; DID = 2'b00;
            DIE = 2'b00; DIF = 2'b00; DIG = 2'b00; DIH = 2'b00;
            @(posedge WCLK);
            #1;
            WE = 0;

            ADDRA = 20; ADDRB = 21; ADDRC = 20; ADDRD = 21;
            ADDRE = 20; ADDRF = 21; ADDRG = 20; ADDRH = 21;
            #1;
            #1;

            check_outputs(1'b1, 1'b0, 1'b1, 1'b0, 1'b1, 1'b0, 1'b1, 2'b00);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("Testcase %0d: WE=0 Write Prevention", test_num);
            @(posedge WCLK);
            WE = 0; ADDRH = 5'd30;
            DIA = 2'b11; DIB = 2'b11; DIC = 2'b11; DID = 2'b11;
            DIE = 2'b11; DIF = 2'b11; DIG = 2'b11; DIH = 2'b11;
            @(posedge WCLK);
            #1;
            ADDRA = 30; ADDRB = 30; ADDRC = 30; ADDRD = 30;
            ADDRE = 30; ADDRF = 30; ADDRG = 30; ADDRH = 30;
            #1;
            #1;

            check_outputs(1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 2'b00);
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
        input expected_DOA;
        input expected_DOB;
        input expected_DOC;
        input expected_DOD;
        input expected_DOE;
        input expected_DOF;
        input expected_DOG;
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
                $display("  Outputs: DOA=%b, DOB=%b, DOC=%b, DOD=%b, DOE=%b, DOF=%b, DOG=%b, DOH=%h",
                         DOA, DOB, DOC, DOD, DOE, DOF, DOG, DOH);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: DOA=%b, DOB=%b, DOC=%b, DOD=%b, DOE=%b, DOF=%b, DOG=%b, DOH=%h",
                         expected_DOA, expected_DOB, expected_DOC, expected_DOD, expected_DOE, expected_DOF, expected_DOG, expected_DOH);
                $display("  Got:      DOA=%b, DOB=%b, DOC=%b, DOD=%b, DOE=%b, DOF=%b, DOG=%b, DOH=%h",
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
