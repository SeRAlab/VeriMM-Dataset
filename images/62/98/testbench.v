`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] A;
    reg [15:0] B;
    reg CLK;
    wire [15:0] RESULT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .CLK(CLK),
        .RESULT(RESULT)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

    begin
        A = 0;
        B = 0;
        @(posedge CLK);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: 0 x 0", test_num);
        reset_dut();
        A = 16'h0000;
        B = 16'h0000;
        @(posedge CLK);
        #2;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: 1234 x 1", test_num);
        reset_dut();
        A = 16'd1234;
        B = 16'd1;
        @(posedge CLK);
        #2;
        #1;

        check_outputs(16'd1234);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: 25 x 4", test_num);
        reset_dut();
        A = 16'd25;
        B = 16'd4;
        @(posedge CLK);
        #2;
        #1;

        check_outputs(16'd100);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: 255 x 255", test_num);
        reset_dut();
        A = 16'h00FF;
        B = 16'h00FF;
        @(posedge CLK);
        #2;
        #1;

        check_outputs(16'hFE01);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: 65535 x 1", test_num);
        reset_dut();
        A = 16'hFFFF;
        B = 16'h0001;
        @(posedge CLK);
        #2;
        #1;

        check_outputs(16'hFFFF);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: 54321 x 0", test_num);
        reset_dut();
        A = 16'd54321;
        B = 16'd0;
        @(posedge CLK);
        #2;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: 0xFFFF x 2 (Truncation)", test_num);
        reset_dut();
        A = 16'hFFFF;
        B = 16'h0002;
        @(posedge CLK);
        #2;

        #1;


        check_outputs(16'hFFFE);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: 0xABCD x 0x1234 (Complex Truncation)", test_num);
        reset_dut();
        A = 16'hABCD;
        B = 16'h1234;
        @(posedge CLK);
        #2;

        #1;


        check_outputs(16'h56A4);
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
        input [15:0] expected_RESULT;
        begin
            if (expected_RESULT === (expected_RESULT ^ RESULT ^ expected_RESULT)) begin
                $display("PASS");
                $display("  Outputs: RESULT=%h",
                         RESULT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: RESULT=%h",
                         expected_RESULT);
                $display("  Got:      RESULT=%h",
                         RESULT);
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
        $dumpvars(0,A, B, CLK, RESULT);
    end

endmodule
