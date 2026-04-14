`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [4:0] ADDRA;
    reg [4:0] ADDRB;
    reg [4:0] ADDRC;
    reg [4:0] ADDRD;
    reg [1:0] DIA;
    reg [1:0] DIB;
    reg [1:0] DIC;
    reg [1:0] DID;
    reg WCLK;
    reg WE;
    wire [1:0] DOA;
    wire [1:0] DOB;
    wire [1:0] DOC;
    wire [1:0] DOD;

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
        .DIA(DIA),
        .DIB(DIB),
        .DIC(DIC),
        .DID(DID),
        .WCLK(WCLK),
        .WE(WE),
        .DOA(DOA),
        .DOB(DOB),
        .DOC(DOC),
        .DOD(DOD)
    );

    // Clock generation (10ns period)
    initial begin
        WCLK = 0;
        forever #5 WCLK = ~WCLK;
    end

        task reset_dut;

        begin
            ADDRA = 5'd0;
            ADDRB = 5'd0;
            ADDRC = 5'd0;
            ADDRD = 5'd0;
            DIA = 2'd0;
            DIB = 2'd0;
            DIC = 2'd0;
            DID = 2'd0;
            WE = 0;
            @(posedge WCLK);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Simultaneous Write to four locations", test_num);
            reset_dut();


            WE = 1;
            ADDRA = 5'd4; DIA = 2'b01;
            ADDRB = 5'd5; DIB = 2'b10;
            ADDRC = 5'd6; DIC = 2'b11;
            ADDRD = 5'd7; DID = 2'b00;

            @(posedge WCLK);
            #1;


            WE = 0;
            ADDRA = 5'd4; ADDRB = 5'd5; ADDRC = 5'd6; ADDRD = 5'd7;
            #2;
            #1;

            check_outputs(2'b01, 2'b10, 2'b11, 2'b00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Verify WE=0 prevents writing", test_num);
            reset_dut();


            WE = 0;
            ADDRA = 5'd10; DIA = 2'b11;
            ADDRB = 5'd11; DIB = 2'b11;
            ADDRC = 5'd12; DIC = 2'b11;
            ADDRD = 5'd13; DID = 2'b11;

            @(posedge WCLK);
            #1;


            ADDRA = 5'd10; ADDRB = 5'd11; ADDRC = 5'd12; ADDRD = 5'd13;
            #2;
            #1;

            check_outputs(2'b00, 2'b00, 2'b00, 2'b00);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: All ports reading the same address", test_num);
            reset_dut();


            WE = 1;
            ADDRA = 5'd15; DIA = 2'b10;
            @(posedge WCLK);
            #1;


            WE = 0;
            ADDRA = 5'd15; ADDRB = 5'd15; ADDRC = 5'd15; ADDRD = 5'd15;
            #2;
            #1;

            check_outputs(2'b10, 2'b10, 2'b10, 2'b10);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Writing to highest addresses", test_num);
            reset_dut();

            WE = 1;
            ADDRA = 5'd28; DIA = 2'b01;
            ADDRB = 5'd29; DIB = 2'b10;
            ADDRC = 5'd30; DIC = 2'b11;
            ADDRD = 5'd31; DID = 2'b01;

            @(posedge WCLK);
            #1;

            WE = 0;
            ADDRA = 5'd28; ADDRB = 5'd29; ADDRC = 5'd30; ADDRD = 5'd31;
            #2;
            #1;

            check_outputs(2'b01, 2'b10, 2'b11, 2'b01);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Sequential overwriting", test_num);
            reset_dut();


            WE = 1;
            ADDRA = 5'd20; DIA = 2'b11;
            @(posedge WCLK);
            #1;


            DIA = 2'b01;
            @(posedge WCLK);
            #1;

            WE = 0;
            ADDRA = 5'd20; ADDRB = 5'd20; ADDRC = 5'd20; ADDRD = 5'd20;
            #2;
            #1;

            check_outputs(2'b01, 2'b01, 2'b01, 2'b01);
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
        begin
            if (expected_DOA === (expected_DOA ^ DOA ^ expected_DOA) &&
                expected_DOB === (expected_DOB ^ DOB ^ expected_DOB) &&
                expected_DOC === (expected_DOC ^ DOC ^ expected_DOC) &&
                expected_DOD === (expected_DOD ^ DOD ^ expected_DOD)) begin
                $display("PASS");
                $display("  Outputs: DOA=%h, DOB=%h, DOC=%h, DOD=%h",
                         DOA, DOB, DOC, DOD);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: DOA=%h, DOB=%h, DOC=%h, DOD=%h",
                         expected_DOA, expected_DOB, expected_DOC, expected_DOD);
                $display("  Got:      DOA=%h, DOB=%h, DOC=%h, DOD=%h",
                         DOA, DOB, DOC, DOD);
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
        $dumpvars(0,ADDRA, ADDRB, ADDRC, ADDRD, DIA, DIB, DIC, DID, WCLK, WE, DOA, DOB, DOC, DOD);
    end

endmodule
