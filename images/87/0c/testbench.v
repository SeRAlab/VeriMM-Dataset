`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] ain;
    reg [15:0] bin;
    reg [15:0] cin;
    reg [7:0] lf;
    wire [15:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ain(ain),
        .bin(bin),
        .cin(cin),
        .lf(lf),
        .out(out)
    );
    task testcase001;

    begin
        $display("Testcase 001: All Zeros function (lf=0)");
        test_num = 1;
        lf = 8'h00;
        ain = 16'hFFFF;
        bin = 16'hAAAA;
        cin = 16'h5555;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase002;

    begin
        $display("Testcase 002: All Ones function (lf=FF)");
        test_num = 2;
        lf = 8'hFF;
        ain = 16'h1234;
        bin = 16'h5678;
        cin = 16'h9ABC;
        #1;

        check_outputs(16'hFFFF);
    end
        endtask

    task testcase003;

    begin
        $display("Testcase 003: Bitwise AND function (lf=80)");
        test_num = 3;
        lf = 8'h80;
        ain = 16'hF0F0;
        bin = 16'hCCCC;
        cin = 16'hAAAA;

        #1;


        check_outputs(16'h8080);
    end
        endtask

    task testcase004;

    begin
        $display("Testcase 004: Bitwise OR function (lf=FE)");
        test_num = 4;
        lf = 8'hFE;
        ain = 16'hF0F0;
        bin = 16'hCCCC;
        cin = 16'hAAAA;

        #1;


        check_outputs(16'hFEEE);
    end
        endtask

    task testcase005;

    begin
        $display("Testcase 005: Bitwise XOR function (lf=96)");
        test_num = 5;
        lf = 8'h96;
        ain = 16'hF0F0;
        bin = 16'hCCCC;
        cin = 16'hAAAA;

        #1;


        check_outputs(16'h9696);
    end
        endtask

    task testcase006;

    begin
        $display("Testcase 006: Minterm 3 Selection (lf=08)");
        test_num = 6;
        lf = 8'h08;
        ain = 16'h00FF;
        bin = 16'h0F0F;
        cin = 16'h3333;

        #1;


        check_outputs(16'h0030);
    end
        endtask

    task testcase007;

    begin
        $display("Testcase 007: Complex Truth Table (lf=CA)");
        test_num = 7;
        lf = 8'hCA;
        ain = 16'hAAAA;
        bin = 16'hCCCC;
        cin = 16'hF0F0;










        #1;











        check_outputs(16'hD8D8);
    end
        endtask

    task testcase008;

    begin
        $display("Testcase 008: Inversion function (out = ~A)");
        test_num = 8;
        lf = 8'h0F;
        ain = 16'hF0F0;
        bin = 16'hFFFF;
        cin = 16'h0000;
        #1;

        check_outputs(16'h0F0F);
    end
        endtask

    task testcase009;

    begin
        $display("Testcase 009: Pass-through function (out = B)");
        test_num = 9;
        lf = 8'hCC;
        ain = 16'h5555;
        bin = 16'hF0F0;
        cin = 16'hAAAA;
        #1;

        check_outputs(16'hF0F0);
    end
        endtask

    task testcase010;

    begin
        $display("Testcase 010: Majority Function (lf=E8)");
        test_num = 10;
        lf = 8'hE8;
        ain = 16'hF0F0;
        bin = 16'hCCCC;
        cin = 16'hAAAA;





        #1;






        check_outputs(16'hE8E8);
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
        input [15:0] expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
