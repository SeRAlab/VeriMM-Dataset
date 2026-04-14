`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg A1;
    reg A2;
    reg B1;
    reg B2;
    reg C1;
    wire Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A1(A1),
        .A2(A2),
        .B1(B1),
        .B2(B2),
        .C1(C1),
        .Y(Y)
    );
    task testcase001;
 begin test_num = 1; {A1,A2,B1,B2,C1} = 5'd0;  $display("Test 001: 00000"); #1;
 check_outputs(1'b0); end     endtask

    task testcase002;
 begin test_num = 2; {A1,A2,B1,B2,C1} = 5'd1;  $display("Test 002: 00001"); #1;
 check_outputs(1'b0); end     endtask

    task testcase003;
 begin test_num = 3; {A1,A2,B1,B2,C1} = 5'd2;  $display("Test 003: 00010"); #1;
 check_outputs(1'b0); end     endtask

    task testcase004;
 begin test_num = 4; {A1,A2,B1,B2,C1} = 5'd3;  $display("Test 004: 00011"); #1;
 check_outputs(1'b0); end     endtask

    task testcase005;
 begin test_num = 5; {A1,A2,B1,B2,C1} = 5'd4;  $display("Test 005: 00100"); #1;
 check_outputs(1'b0); end     endtask

    task testcase006;
 begin test_num = 6; {A1,A2,B1,B2,C1} = 5'd5;  $display("Test 006: 00101"); #1;
 check_outputs(1'b0); end     endtask

    task testcase007;
 begin test_num = 7; {A1,A2,B1,B2,C1} = 5'd6;  $display("Test 007: 00110"); #1;
 check_outputs(1'b0); end     endtask

    task testcase008;
 begin test_num = 8; {A1,A2,B1,B2,C1} = 5'd7;  $display("Test 008: 00111"); #1;
 check_outputs(1'b0); end     endtask

    task testcase009;
 begin test_num = 9; {A1,A2,B1,B2,C1} = 5'd8;  $display("Test 009: 01000"); #1;
 check_outputs(1'b1); end     endtask

    task testcase010;
 begin test_num = 10; {A1,A2,B1,B2,C1} = 5'd9; $display("Test 010: 01001"); #1;
 check_outputs(1'b1); end     endtask

    task testcase011;
 begin test_num = 11; {A1,A2,B1,B2,C1} = 5'd10; $display("Test 011: 01010"); #1;
 check_outputs(1'b0); end     endtask

    task testcase012;
 begin test_num = 12; {A1,A2,B1,B2,C1} = 5'd11; $display("Test 012: 01100"); #1;
 check_outputs(1'b1); end     endtask

    task testcase013;
 begin test_num = 13; {A1,A2,B1,B2,C1} = 5'd12; $display("Test 013: 01101"); #1;
 check_outputs(1'b1); end     endtask

    task testcase014;
 begin test_num = 14; {A1,A2,B1,B2,C1} = 5'd13; $display("Test 014: 01110"); #1;
 check_outputs(1'b1); end     endtask

    task testcase015;
 begin test_num = 15; {A1,A2,B1,B2,C1} = 5'd14; $display("Test 015: 01111"); #1;
 check_outputs(1'b0); end     endtask

    task testcase016;
 begin test_num = 16; {A1,A2,B1,B2,C1} = 5'd15; $display("Test 016: 10000"); #1;
 check_outputs(1'b1); end     endtask

    task testcase017;
 begin test_num = 17; {A1,A2,B1,B2,C1} = 5'd16; $display("Test 017: 10001"); #1;
 check_outputs(1'b1); end     endtask

    task testcase018;
 begin test_num = 18; {A1,A2,B1,B2,C1} = 5'd17; $display("Test 018: 10010"); #1;
 check_outputs(1'b0); end     endtask

    task testcase019;
 begin test_num = 19; {A1,A2,B1,B2,C1} = 5'd18; $display("Test 019: 10011"); #1;
 check_outputs(1'b0); end     endtask

    task testcase020;
 begin test_num = 20; {A1,A2,B1,B2,C1} = 5'd19; $display("Test 020: 10100"); #1;
 check_outputs(1'b1); end     endtask

    task testcase021;
 begin test_num = 21; {A1,A2,B1,B2,C1} = 5'd20; $display("Test 021: 10101"); #1;
 check_outputs(1'b0); end     endtask

    task testcase022;
 begin test_num = 22; {A1,A2,B1,B2,C1} = 5'd21; $display("Test 022: 10110"); #1;
 check_outputs(1'b1); end     endtask

    task testcase023;
 begin test_num = 23; {A1,A2,B1,B2,C1} = 5'd22; $display("Test 023: 10111"); #1;
 check_outputs(1'b1); end     endtask

    task testcase024;
 begin test_num = 24; {A1,A2,B1,B2,C1} = 5'd23; $display("Test 024: 11000"); #1;
 check_outputs(1'b1); end     endtask

    task testcase025;
 begin test_num = 25; {A1,A2,B1,B2,C1} = 5'd24; $display("Test 025: 11001"); #1;
 check_outputs(1'b1); end     endtask

    task testcase026;
 begin test_num = 26; {A1,A2,B1,B2,C1} = 5'd25; $display("Test 026: 11010"); #1;
 check_outputs(1'b1); end     endtask

    task testcase027;
 begin test_num = 27; {A1,A2,B1,B2,C1} = 5'd26; $display("Test 027: 11011"); #1;
 check_outputs(1'b1); end     endtask

    task testcase028;
 begin test_num = 28; {A1,A2,B1,B2,C1} = 5'd27; $display("Test 028: 11100"); #1;
 check_outputs(1'b0); end     endtask

    task testcase029;
 begin test_num = 29; {A1,A2,B1,B2,C1} = 5'd28; $display("Test 029: 11101"); #1;
 check_outputs(1'b0); end     endtask

    task testcase030;
 begin test_num = 30; {A1,A2,B1,B2,C1} = 5'd29; $display("Test 030: 11110"); #1;
 check_outputs(1'b0); end     endtask

    task testcase031;
 begin test_num = 31; {A1,A2,B1,B2,C1} = 5'd30; $display("Test 031: 11111"); #1;
 check_outputs(1'b1); end     endtask

    task testcase032;
 begin test_num = 32; {A1,A2,B1,B2,C1} = 5'd31; $display("Test 032: Corner Case Max"); #1;
 check_outputs(1'b1); end     endtask

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
        testcase007();
        testcase008();
        testcase009();
        testcase010();
        testcase011();
        testcase012();
        testcase013();
        testcase014();
        testcase015();
        testcase016();
        testcase017();
        testcase018();
        testcase019();
        testcase020();
        testcase021();
        testcase022();
        testcase023();
        testcase024();
        testcase025();
        testcase026();
        testcase027();
        testcase028();
        testcase029();
        testcase030();
        testcase031();
        testcase032();
        
        
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
        input expected_Y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Y === (expected_Y ^ Y ^ expected_Y)) begin
                $display("PASS");
                $display("  Outputs: Y=%b",
                         Y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Y=%b",
                         expected_Y);
                $display("  Got:      Y=%b",
                         Y);
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
