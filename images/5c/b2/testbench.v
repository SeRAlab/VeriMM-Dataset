`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [4:0] addrA;
    reg [4:0] addrB;
    reg [4:0] addrC;
    reg clk;
    reg [31:0] data;
    reg reset;
    reg we;
    wire [31:0] outA;
    wire [31:0] outB;
    wire [31:0] outC;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addrA(addrA),
        .addrB(addrB),
        .addrC(addrC),
        .clk(clk),
        .data(data),
        .reset(reset),
        .we(we),
        .outA(outA),
        .outB(outB),
        .outC(outC)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        we = 0;
        addrA = 0;
        addrB = 0;
        addrC = 0;
        data = 0;
        @(posedge clk);
        #1 reset = 0;



        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Reset Verification", test_num);
        reset_dut();


        addrA = 5;
        addrB = 15;
        addrC = 31;


        @(posedge clk);
        #1;
        #1;

        check_outputs(32'h0, 32'h0, 32'h0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Single Write and Read", test_num);
        reset_dut();


        we = 1;
        addrC = 10;
        data = 32'hABCDE001;
        @(posedge clk);
        #1;


        we = 0;
        addrA = 10;
        addrB = 10;
        addrC = 10;


        @(posedge clk);
        #1;
        #1;

        check_outputs(32'hABCDE001, 32'hABCDE001, 32'hABCDE001);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Simultaneous Multi-Register Read", test_num);
        reset_dut();


        we = 1; addrC = 1; data = 32'h11111111;
        @(posedge clk); #1;


        we = 1; addrC = 2; data = 32'h22222222;
        @(posedge clk); #1;


        we = 1; addrC = 3; data = 32'h33333333;
        @(posedge clk); #1;


        we = 0;
        addrA = 1;
        addrB = 2;
        addrC = 3;

        @(posedge clk);
        #1;
        #1;

        check_outputs(32'h11111111, 32'h22222222, 32'h33333333);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Write Enable Check", test_num);
        reset_dut();


        we = 1; addrC = 5; data = 32'h55555555;
        @(posedge clk); #1;


        we = 0; addrC = 5; data = 32'hFFFFFFFF;
        @(posedge clk); #1;


        addrA = 5; addrB = 5; addrC = 5;
        @(posedge clk);
        #1;

        #1;


        check_outputs(32'h55555555, 32'h55555555, 32'h55555555);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Boundary Register Check (0 and 31)", test_num);
        reset_dut();


        we = 1; addrC = 0; data = 32'hAAAAAAAA;
        @(posedge clk); #1;


        we = 1; addrC = 31; data = 32'hBBBBBBBB;
        @(posedge clk); #1;


        we = 0;
        addrA = 0;
        addrB = 31;
        addrC = 0;

        @(posedge clk);
        #1;
        #1;

        check_outputs(32'hAAAAAAAA, 32'hBBBBBBBB, 32'hAAAAAAAA);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Overwrite Register", test_num);
        reset_dut();


        we = 1; addrC = 20; data = 32'h12341234;
        @(posedge clk); #1;


        we = 1; addrC = 20; data = 32'h98769876;
        @(posedge clk); #1;


        we = 0;
        addrA = 20; addrB = 20; addrC = 20;
        @(posedge clk);
        #1;
        #1;

        check_outputs(32'h98769876, 32'h98769876, 32'h98769876);
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
        input [31:0] expected_outA;
        input [31:0] expected_outB;
        input [31:0] expected_outC;
        begin
            if (expected_outA === (expected_outA ^ outA ^ expected_outA) &&
                expected_outB === (expected_outB ^ outB ^ expected_outB) &&
                expected_outC === (expected_outC ^ outC ^ expected_outC)) begin
                $display("PASS");
                $display("  Outputs: outA=%h, outB=%h, outC=%h",
                         outA, outB, outC);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: outA=%h, outB=%h, outC=%h",
                         expected_outA, expected_outB, expected_outC);
                $display("  Got:      outA=%h, outB=%h, outC=%h",
                         outA, outB, outC);
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
        $dumpvars(0,addrA, addrB, addrC, clk, data, reset, we, outA, outB, outC);
    end

endmodule
