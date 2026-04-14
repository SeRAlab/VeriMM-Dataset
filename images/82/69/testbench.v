`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [4:0] A;
    reg CLK;
    reg [31:0] DI;
    reg [4:0] WA;
    reg WE;
    wire [31:0] O;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .CLK(CLK),
        .DI(DI),
        .WA(WA),
        .WE(WE),
        .O(O)
    );

        task reset_dut;

    begin
        A = 5'b0;
        CLK = 0;
        DI = 32'b0;
        WA = 5'b0;
        WE = 0;
        #10;
    end
        endtask
    task cycle;

        begin
            #5 CLK = 1;
            #5 CLK = 0;
        end
        endtask

    task testcase001;

    begin
        reset_dut();
        test_num = 1;
        WE = 1;
        WA = 5'd0;
        DI = 32'hA5A5_A5A5;
        cycle();
        WE = 0;
        A = 5'd0;
        #5;
        #1;

        check_outputs(32'hA5A5_A5A5);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = 2;
        WE = 1;
        WA = 5'd31;
        DI = 32'hFFFF_0000;
        cycle();
        WE = 0;
        A = 5'd31;
        #5;
        #1;

        check_outputs(32'hFFFF_0000);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = 3;

        WE = 1; WA = 5'd5; DI = 32'h1111_1111;
        cycle();

        WE = 0; WA = 5'd5; DI = 32'hEEEE_EEEE;
        cycle();
        A = 5'd5;
        #5;
        #1;

        check_outputs(32'h1111_1111);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = 4;

        WE = 1; WA = 5'd10; DI = 32'hCAFE_BABE;
        cycle();

        WE = 0; WA = 5'd20; A = 5'd10;
        #5;
        #1;

        check_outputs(32'hCAFE_BABE);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = 5;

        WE = 1; WA = 5'd2; DI = 32'h8888_8888;
        cycle();

        WE = 1; WA = 5'd3; DI = 32'h9999_9999;
        cycle();

        A = 5'd2;
        #5;
        #1;

        check_outputs(32'h8888_8888);
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        test_num = 6;
        WE = 1; WA = 5'd15; DI = 32'h0000_1234;
        cycle();
        DI = 32'h5678_0000;
        cycle();
        WE = 0;
        A = 5'd15;
        #5;
        #1;

        check_outputs(32'h5678_0000);
    end
        endtask

    task testcase007;

    begin
        reset_dut();
        test_num = 7;
        WE = 1; WA = 5'd7; A = 5'd7; DI = 32'hABCD_EF01;
        cycle();
        #5;
        #1;

        check_outputs(32'hABCD_EF01);
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
        input [31:0] expected_O;
        begin
            if (expected_O === (expected_O ^ O ^ expected_O)) begin
                $display("PASS");
                $display("  Outputs: O=%h",
                         O);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: O=%h",
                         expected_O);
                $display("  Got:      O=%h",
                         O);
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
        $dumpvars(0,A, CLK, DI, WA, WE, O);
    end

endmodule
