`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] Ctrl;
    reg [25:0] Imm26;
    wire [63:0] BusImm;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Ctrl(Ctrl),
        .Imm26(Imm26),
        .BusImm(BusImm)
    );
    task testcase001;

    begin
        test_num = 1;
        Ctrl = 2'b00;
        Imm26 = 26'h0000_123;
        $display("Test %0d: Ctrl=00, Imm12=0x123 (Positive)", test_num);
        #1;

        check_outputs(64'h0000_0000_0000_0123);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        Ctrl = 2'b00;
        Imm26 = 26'h0000_800;
        $display("Test %0d: Ctrl=00, Imm12=0x800 (Negative)", test_num);
        #1;

        check_outputs(64'hFFFF_FFFF_FFFF_F800);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        Ctrl = 2'b01;
        Imm26 = 26'h0000_7ABC;
        $display("Test %0d: Ctrl=01, Imm16=0x7ABC (Positive)", test_num);
        #1;

        check_outputs(64'h0000_0000_0000_7ABC);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        Ctrl = 2'b01;
        Imm26 = 26'h0000_F000;
        $display("Test %0d: Ctrl=01, Imm16=0xF000 (Negative)", test_num);
        #1;

        check_outputs(64'hFFFF_FFFF_FFFF_F000);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        Ctrl = 2'b10;
        Imm26 = 26'h007_FFFF;
        $display("Test %0d: Ctrl=10, Imm20=0x7FFFF (Positive)", test_num);
        #1;

        check_outputs(64'h0000_0000_0007_FFFF);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        Ctrl = 2'b10;
        Imm26 = 26'h008_0000;
        $display("Test %0d: Ctrl=10, Imm20=0x80000 (Negative)", test_num);
        #1;

        check_outputs(64'hFFFF_FFFF_FFF8_0000);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        Ctrl = 2'b11;
        Imm26 = 26'h1FF_FFFF;
        $display("Test %0d: Ctrl=11, Imm26=0x1FFFFFF (Positive)", test_num);
        #1;

        check_outputs(64'h0000_0000_01FF_FFFF);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        Ctrl = 2'b11;
        Imm26 = 26'h200_0000;
        $display("Test %0d: Ctrl=11, Imm26=0x2000000 (Negative)", test_num);
        #1;

        check_outputs(64'hFFFF_FFFF_FE00_0000);
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
        input [63:0] expected_BusImm;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_BusImm === (expected_BusImm ^ BusImm ^ expected_BusImm)) begin
                $display("PASS");
                $display("  Outputs: BusImm=%h",
                         BusImm);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: BusImm=%h",
                         expected_BusImm);
                $display("  Got:      BusImm=%h",
                         BusImm);
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
