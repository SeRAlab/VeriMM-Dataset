`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] din0;
    reg [31:0] din1;
    reg [31:0] din2;
    reg [31:0] din3;
    reg [1:0] op;
    wire [31:0] dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .din0(din0),
        .din1(din1),
        .din2(din2),
        .din3(din3),
        .op(op),
        .dout(dout)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %03d: Select din0 (op=00)", test_num);
        din0 = 32'h1234_5678;
        din1 = 32'hAAAA_AAAA;
        din2 = 32'hBBBB_BBBB;
        din3 = 32'hCCCC_CCCC;
        op = 2'b00;
        #1;

        check_outputs(32'h1234_5678);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %03d: Select din1 (op=01)", test_num);
        din0 = 32'h1111_1111;
        din1 = 32'h2222_2222;
        din2 = 32'h3333_3333;
        din3 = 32'h4444_4444;
        op = 2'b01;
        #1;

        check_outputs(32'h2222_2222);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %03d: Select din2 (op=10)", test_num);
        din0 = 32'hFEED_BEEF;
        din1 = 32'hDEAD_BEEF;
        din2 = 32'hCAFE_BABE;
        din3 = 32'h0000_FFFF;
        op = 2'b10;
        #1;

        check_outputs(32'hCAFE_BABE);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %03d: Select din3 (op=11)", test_num);
        din0 = 32'h0;
        din1 = 32'h1;
        din2 = 32'h2;
        din3 = 32'hFFFF_FFFF;
        op = 2'b11;
        #1;

        check_outputs(32'hFFFF_FFFF);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %03d: All inputs zero, select din2", test_num);
        din0 = 32'h0;
        din1 = 32'h0;
        din2 = 32'h0;
        din3 = 32'h0;
        op = 2'b10;
        #1;

        check_outputs(32'h0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %03d: Boundary check (op=01)", test_num);
        din0 = 32'h7FFF_FFFF;
        din1 = 32'h8000_0000;
        din2 = 32'h0000_0001;
        din3 = 32'hFFFF_FFFE;
        op = 2'b01;
        #1;

        check_outputs(32'h8000_0000);
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
        input [31:0] expected_dout;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_dout === (expected_dout ^ dout ^ expected_dout)) begin
                $display("PASS");
                $display("  Outputs: dout=%h",
                         dout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dout=%h",
                         expected_dout);
                $display("  Got:      dout=%h",
                         dout);
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
