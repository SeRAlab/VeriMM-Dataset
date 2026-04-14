`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] ADDR;
    reg CLK;
    reg [15:0] DI;
    reg EN;
    reg RST;
    reg WE;
    wire [15:0] DO;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ADDR(ADDR),
        .CLK(CLK),
        .DI(DI),
        .EN(EN),
        .RST(RST),
        .WE(WE),
        .DO(DO)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            RST = 1;
            ADDR = 0;
            DI = 0;
            EN = 0;
            WE = 0;
            @(posedge CLK);
            #2;
            RST = 0;
            @(posedge CLK);
            #2;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase 001: Basic Write and Read at 0x0A");


            EN = 1;
            WE = 1;
            ADDR = 8'h0A;
            DI = 16'hAAAA;
            @(posedge CLK);
            #2;


            WE = 0;
            ADDR = 8'h0A;
            @(posedge CLK);
            #2;
            @(posedge CLK);
            #2;

            #1;


            check_outputs(16'hAAAA);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase 002: Boundary Check at 0xFF");


            EN = 1;
            WE = 1;
            ADDR = 8'hFF;
            DI = 16'h5555;
            @(posedge CLK);
            #2;


            WE = 0;
            ADDR = 8'hFF;
            @(posedge CLK);
            #2;
            @(posedge CLK);
            #2;

            #1;


            check_outputs(16'h5555);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase 003: EN Disable Check");


            EN = 0;
            WE = 1;
            ADDR = 8'h20;
            DI = 16'hDEAD;
            @(posedge CLK);
            #2;


            EN = 1;
            WE = 0;
            ADDR = 8'h20;
            @(posedge CLK);
            #2;
            @(posedge CLK);
            #2;


            #1;



            check_outputs(16'h0000);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase 004: WE Disable Check");


            EN = 1;
            WE = 1;
            ADDR = 8'h30;
            DI = 16'hBEEF;
            @(posedge CLK);
            #2;


            WE = 0;
            DI = 16'hCAFE;
            @(posedge CLK);
            #2;


            ADDR = 8'h30;
            @(posedge CLK);
            #2;
            @(posedge CLK);
            #2;

            #1;


            check_outputs(16'hBEEF);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase 005: Sequential Read Check");


            EN = 1; WE = 1; ADDR = 8'h40; DI = 16'h1111;
            @(posedge CLK); #2;

            ADDR = 8'h41; DI = 16'h2222;
            @(posedge CLK); #2;


            WE = 0; ADDR = 8'h41;
            @(posedge CLK); #2;
            @(posedge CLK); #2;


            ADDR = 8'h40;
            @(posedge CLK); #2;
            @(posedge CLK); #2;

            #1;


            check_outputs(16'h1111);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("Testcase 006: Output Reset Check");


            EN = 1; WE = 1; ADDR = 8'h50; DI = 16'h1234;
            @(posedge CLK); #2;


            WE = 0; ADDR = 8'h50;
            @(posedge CLK); #2;
            RST = 1;
            @(posedge CLK); #2;
            RST = 0;
            @(posedge CLK); #2;


            #1;



            check_outputs(16'h0000);
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
        input [15:0] expected_DO;
        begin
            if (expected_DO === (expected_DO ^ DO ^ expected_DO)) begin
                $display("PASS");
                $display("  Outputs: DO=%h",
                         DO);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: DO=%h",
                         expected_DO);
                $display("  Got:      DO=%h",
                         DO);
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
        $dumpvars(0,ADDR, CLK, DI, EN, RST, WE, DO);
    end

endmodule
