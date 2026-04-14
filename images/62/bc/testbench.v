`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] narrow;
    reg [63:0] quad;
    wire [31:0] longout;
    wire [63:0] quadout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .narrow(narrow),
        .quad(quad),
        .longout(longout),
        .quadout(quadout)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %03d: All Zeros", test_num);
        narrow = 8'h00;
        quad = 64'h0000000000000000;
        #1;

        check_outputs(32'h00000000, 64'h0000000000000000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %03d: All Ones", test_num);
        narrow = 8'hFF;
        quad = 64'hFFFFFFFFFFFFFFFF;
        #1;

        check_outputs(32'hFFFFFFFF, 64'hFFFFFFFFFFFFFFFF);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %03d: Lower Boundary (0x7F)", test_num);
        narrow = 8'h7F;
        quad = 64'h7FFFFFFFFFFFFFFF;
        #1;

        check_outputs(32'h00000000, 64'h0000000000000000);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %03d: Upper Boundary (0x80)", test_num);
        narrow = 8'h80;
        quad = 64'h8000000000000000;
        #1;

        check_outputs(32'hFFFFFFFF, 64'hFFFFFFFFFFFFFFFF);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %03d: Alternating Bits 0101", test_num);
        narrow = 8'h55;
        quad = 64'h5555555555555555;
        #1;

        check_outputs(32'h00000000, 64'h0000000000000000);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %03d: Alternating Bits 1010", test_num);
        narrow = 8'hAA;
        quad = 64'hAAAAAAAAAAAAAAAA;
        #1;

        check_outputs(32'hFFFFFFFF, 64'hFFFFFFFFFFFFFFFF);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %03d: LSB Only", test_num);
        narrow = 8'h01;
        quad = 64'h0000000000000001;
        #1;

        check_outputs(32'h00000000, 64'h0000000000000000);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %03d: High Nibble Set", test_num);
        narrow = 8'hF0;
        quad = 64'hF0F0F0F000000000;
        #1;

        check_outputs(32'hFFFFFFFF, 64'hFFFFFFFFFFFFFFFF);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %03d: Mid-range Values", test_num);
        narrow = 8'd100;
        quad = 64'h123456789ABCDEF0;
        #1;

        check_outputs(32'h00000000, 64'h0000000000000000);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %03d: MSB Power of 2", test_num);
        narrow = 8'h40;
        quad = 64'h4000000000000000;
        #1;

        check_outputs(32'h00000000, 64'h0000000000000000);
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
        testcase007();
        testcase008();
        testcase009();
        testcase010();
        
        
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
        input [31:0] expected_longout;
        input [63:0] expected_quadout;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_longout === (expected_longout ^ longout ^ expected_longout) &&
                expected_quadout === (expected_quadout ^ quadout ^ expected_quadout)) begin
                $display("PASS");
                $display("  Outputs: longout=%h, quadout=%h",
                         longout, quadout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: longout=%h, quadout=%h",
                         expected_longout, expected_quadout);
                $display("  Got:      longout=%h, quadout=%h",
                         longout, quadout);
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
