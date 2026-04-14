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
        $display("Testcase %0d: Ctrl=00, Imm26=All 1s", test_num);
        Ctrl = 2'b00;
        Imm26 = 26'h3FFFFFF;
        #1;

        check_outputs(64'h0000000000000FFF);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Ctrl=00, Imm26 shifted 0xABC", test_num);
        Ctrl = 2'b00;
        Imm26 = 26'h2AF400;
        #1;

        check_outputs(64'h0000000000000ABC);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Ctrl=01, 21-bit Negative", test_num);
        Ctrl = 2'b01;
        Imm26 = 26'h100000;
        #1;

        check_outputs(64'hFFFFFFFFFFF00000);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Ctrl=01, 21-bit Positive", test_num);
        Ctrl = 2'b01;
        Imm26 = 26'h07FFFF;
        #1;

        check_outputs(64'h000000000007FFFF);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Ctrl=10, 26-bit Negative", test_num);
        Ctrl = 2'b10;
        Imm26 = 26'h2000000;
        #1;

        check_outputs(64'hFFFFFFFFFE000000);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Ctrl=10, 26-bit Positive", test_num);
        Ctrl = 2'b10;
        Imm26 = 26'h1FFFFFF;
        #1;

        check_outputs(64'h0000000001FFFFFF);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Ctrl=11, 24-bit Negative", test_num);
        Ctrl = 2'b11;
        Imm26 = 26'h800000;
        #1;

        check_outputs(64'hFFFFFFFFFF800000);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: Ctrl=11, 24-bit Positive", test_num);
        Ctrl = 2'b11;
        Imm26 = 26'h7FFFFF;
        #1;

        check_outputs(64'h00000000007FFFFF);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Testcase %0d: Ctrl=00, Zero Input", test_num);
        Ctrl = 2'b00;
        Imm26 = 26'h0;
        #1;

        check_outputs(64'h0);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Testcase %0d: Ctrl=11, High bits set", test_num);
        Ctrl = 2'b11;
        Imm26 = 26'h3000000;
        #1;

        check_outputs(64'h0000000000000000);
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
