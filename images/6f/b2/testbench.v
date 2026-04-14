`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [10:0] ADDR;
    reg CLK;
    reg [7:0] DI;
    reg DIP;
    reg EN;
    reg SSR;
    reg WE;
    wire [7:0] DO;
    wire DOP;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ADDR(ADDR),
        .CLK(CLK),
        .DI(DI),
        .DIP(DIP),
        .EN(EN),
        .SSR(SSR),
        .WE(WE),
        .DO(DO),
        .DOP(DOP)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            SSR = 1;
            EN = 1;
            WE = 0;
            ADDR = 0;
            DI = 0;
            DIP = 0;
            @(posedge CLK);
            #1;
            SSR = 0;
            EN = 0;
            @(posedge CLK);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase 001: Basic Write and Read...");


            @(posedge CLK);
            EN = 1; WE = 1; ADDR = 11'h010; DI = 8'hA5; DIP = 1'b1;
            @(posedge CLK);


            WE = 0; ADDR = 11'h010;
            @(posedge CLK);
            #2;

            #1;


            check_outputs(8'hA5, 1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase 002: Boundary Address (0x7FF)...");


            @(posedge CLK);
            EN = 1; WE = 1; ADDR = 11'h7FF; DI = 8'h55; DIP = 1'b0;
            @(posedge CLK);


            WE = 0; ADDR = 11'h7FF;
            @(posedge CLK);
            #2;

            #1;


            check_outputs(8'h55, 1'b0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase 003: Enable (EN) Check...");


            @(posedge CLK);
            EN = 1; WE = 1; ADDR = 11'h020; DI = 8'h11; DIP = 1'b1;
            @(posedge CLK);


            EN = 0; WE = 1; ADDR = 11'h020; DI = 8'hEE; DIP = 1'b0;
            @(posedge CLK);


            EN = 1; WE = 0; ADDR = 11'h020;
            @(posedge CLK);
            #2;

            #1;


            check_outputs(8'h11, 1'b1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase 004: SSR Output Reset...");


            @(posedge CLK);
            EN = 1; WE = 1; ADDR = 11'h030; DI = 8'hFF; DIP = 1'b1;
            @(posedge CLK);


            WE = 0; ADDR = 11'h030;
            @(posedge CLK);
            #2;


            @(posedge CLK);
            SSR = 1; EN = 1;
            @(posedge CLK);
            #2;


            #1;



            check_outputs(8'h00, 1'b0);
            SSR = 0;
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase 005: Multiple Address Integrity...");


            @(posedge CLK);
            EN = 1; WE = 1; ADDR = 11'h100; DI = 8'hAA; DIP = 1'b0;
            @(posedge CLK);


            ADDR = 11'h200; DI = 8'hBB; DIP = 1'b1;
            @(posedge CLK);


            WE = 0; ADDR = 11'h100;
            @(posedge CLK);
            #2;

            if (DO !== 8'hAA || DOP !== 1'b0) begin
                 #1;

                 check_outputs(8'hAA, 1'b0);
            end else begin

                ADDR = 11'h200;
                @(posedge CLK);
                #2;
                #1;

                check_outputs(8'hBB, 1'b1);
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
        input [7:0] expected_DO;
        input expected_DOP;
        begin
            if (expected_DO === (expected_DO ^ DO ^ expected_DO) &&
                expected_DOP === (expected_DOP ^ DOP ^ expected_DOP)) begin
                $display("PASS");
                $display("  Outputs: DO=%h, DOP=%b",
                         DO, DOP);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: DO=%h, DOP=%b",
                         expected_DO, expected_DOP);
                $display("  Got:      DO=%h, DOP=%b",
                         DO, DOP);
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
        $dumpvars(0,ADDR, CLK, DI, DIP, EN, SSR, WE, DO, DOP);
    end

endmodule
