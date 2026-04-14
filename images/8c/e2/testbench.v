`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] apqrli;
    reg [215:0] drricx;
    reg [15:0] dzosui;
    reg [255:0] mglehy;
    reg [2:0] szlfpf;
    reg [31:0] zndrba;
    wire [223:0] bxiouf;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .apqrli(apqrli),
        .drricx(drricx),
        .dzosui(dzosui),
        .mglehy(mglehy),
        .szlfpf(szlfpf),
        .zndrba(zndrba),
        .bxiouf(bxiouf)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case 001: All Zeros");
            mglehy = 256'h0;
            drricx = 216'h0;
            apqrli = 16'h0;
            szlfpf = 3'h0;
            dzosui = 16'h0;
            zndrba = 32'h0;
            #10;


            #1;



            check_outputs(224'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case 002: All Ones");
            mglehy = {8{32'hFFFFFFFF}};
            drricx = {7{32'hFFFFFFFF}};
            drricx = 216'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
            apqrli = 16'hFFFF;
            szlfpf = 3'h7;
            dzosui = 16'hFFFF;
            zndrba = 32'hFFFFFFFF;
            #10;

            #1;


            check_outputs(224'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case 003: Checkerboard Pattern");
            mglehy = {128{2'b10}};
            drricx = {108{2'b01}};
            apqrli = 16'hAAAA;
            szlfpf = 3'h2;
            dzosui = 16'h5555;
            zndrba = 32'hAAAAAAAA;
            #10;

            #1;


            check_outputs(224'hAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case 004: Walking Ones (Small Inputs)");
            mglehy = 256'h0;
            drricx = 216'h0;
            apqrli = 16'h0001;
            szlfpf = 3'h4;
            dzosui = 16'h8000;
            zndrba = 32'h00000001;
            #10;

            #1;


            check_outputs(224'h00000000000000000000000000000000000000000000000000000001);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case 005: Bus Boundary Test");

            mglehy = 256'hF00000000000000000000000000000000000000000000000000000000000000F;
            drricx = 216'hE00000000000000000000000000000000000000000000000000007;
            apqrli = 16'h1234;
            szlfpf = 3'h5;
            dzosui = 16'h5678;
            zndrba = 32'h9ABCDEF0;
            #10;

            #1;


            check_outputs(224'hBCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case 006: Control Signal Toggle (szlfpf)");
            mglehy = 256'hFEEDFACECAFEBEEFDEADC0DEBAADF00DFEEDFACECAFEBEEFDEADC0DEBAADF00D;
            drricx = 216'hBADC0FFEEBADC0FFEEBADC0FFEEBADC0FFEEBADC0FFEEBADC0FFEEBA;
            apqrli = 16'h1357;
            dzosui = 16'h2468;
            zndrba = 32'h0;


            szlfpf = 3'h1; #10;
            szlfpf = 3'h3; #10;
            szlfpf = 3'h6; #10;


            #1;



            check_outputs(224'hDEADC0DEBAADF00DFEEDFACECAFEBEEFDEADC0DEBAADF00D13572468);
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
        input [223:0] expected_bxiouf;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_bxiouf === (expected_bxiouf ^ bxiouf ^ expected_bxiouf)) begin
                $display("PASS");
                $display("  Outputs: bxiouf=%h",
                         bxiouf);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: bxiouf=%h",
                         expected_bxiouf);
                $display("  Got:      bxiouf=%h",
                         bxiouf);
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

endmodule
