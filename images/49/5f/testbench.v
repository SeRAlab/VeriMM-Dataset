`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CAPTURE_DR;
    reg CLK;
    reg CLKEN;
    reg DATA_IN;
    reg RESET_N;
    reg TDI;
    wire TDO;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CAPTURE_DR(CAPTURE_DR),
        .CLK(CLK),
        .CLKEN(CLKEN),
        .DATA_IN(DATA_IN),
        .RESET_N(RESET_N),
        .TDI(TDI),
        .TDO(TDO)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

    begin
        RESET_N = 0;
        CLKEN = 0;
        TDI = 0;
        DATA_IN = 0;
        CAPTURE_DR = 0;
        #20;
        RESET_N = 1;
        #10;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Reset behavior", test_num);
        reset_dut();

        #1;


        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Capture DATA_IN (High)", test_num);
        reset_dut();
        @(posedge CLK);
        CLKEN = 1;
        CAPTURE_DR = 1;
        DATA_IN = 1;
        @(posedge CLK);
        #2;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Capture DATA_IN (Low)", test_num);
        reset_dut();

        @(posedge CLK);
        CLKEN = 1; CAPTURE_DR = 1; DATA_IN = 1;
        @(posedge CLK);

        DATA_IN = 0;
        @(posedge CLK);
        #2;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Shift TDI (High)", test_num);
        reset_dut();
        @(posedge CLK);
        CLKEN = 1;
        CAPTURE_DR = 0;
        TDI = 1;
        @(posedge CLK);
        #2;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Shift TDI (Low)", test_num);
        reset_dut();

        @(posedge CLK);
        CLKEN = 1; CAPTURE_DR = 0; TDI = 1;
        @(posedge CLK);

        TDI = 0;
        @(posedge CLK);
        #2;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Clock Enable (Hold state)", test_num);
        reset_dut();

        @(posedge CLK);
        CLKEN = 1; CAPTURE_DR = 1; DATA_IN = 1;
        @(posedge CLK);

        CLKEN = 0;
        DATA_IN = 0;
        TDI = 0;
        @(posedge CLK);
        #2;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: CAPTURE_DR Priority", test_num);
        reset_dut();
        @(posedge CLK);
        CLKEN = 1;
        CAPTURE_DR = 1;
        DATA_IN = 1;
        TDI = 0;
        @(posedge CLK);
        #2;
        #1;

        check_outputs(1'b1);
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
        input expected_TDO;
        begin
            if (expected_TDO === (expected_TDO ^ TDO ^ expected_TDO)) begin
                $display("PASS");
                $display("  Outputs: TDO=%b",
                         TDO);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: TDO=%b",
                         expected_TDO);
                $display("  Got:      TDO=%b",
                         TDO);
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
        $dumpvars(0,CAPTURE_DR, CLK, CLKEN, DATA_IN, RESET_N, TDI, TDO);
    end

endmodule
