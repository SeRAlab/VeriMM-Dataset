`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CAPTURE_DR;
    reg CLK;
    reg CLKEN;
    reg DATA_IN;
    reg RESET_N;
    reg TDI;
    reg UPDATE_DR;
    wire [7:0] DATA_OUT;
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
        .UPDATE_DR(UPDATE_DR),
        .DATA_OUT(DATA_OUT),
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
            CAPTURE_DR = 0;
            CLKEN = 0;
            DATA_IN = 0;
            TDI = 0;
            UPDATE_DR = 0;
            #15;
            RESET_N = 1;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Reset Verification", test_num);
            reset_dut();

            #1;


            check_outputs(8'h00, 1'b0);
        end
        endtask

    task testcase002;

        integer i;
        reg [7:0] pattern;
        begin
            test_num = test_num + 1;
            $display("Testcase %03d: TDI Serial Shift and Update", test_num);
            reset_dut();
            pattern = 8'hA5;
            CLKEN = 1;
            CAPTURE_DR = 0;

            for (i = 0; i < 8; i = i + 1) begin
                TDI = pattern[i];
                @(negedge CLK);
            end

            UPDATE_DR = 1;
            @(negedge CLK);
            UPDATE_DR = 0;

            #1;


            check_outputs(8'hA5, 1'b1);
        end
        endtask

    task testcase003;

        integer i;
        reg [7:0] pattern;
        begin
            test_num = test_num + 1;
            $display("Testcase %03d: DATA_IN Serial Shift and Update", test_num);
            reset_dut();
            pattern = 8'h3C;
            CLKEN = 1;
            CAPTURE_DR = 1;
            for (i = 0; i < 8; i = i + 1) begin
                DATA_IN = pattern[i];
                @(negedge CLK);
            end
            UPDATE_DR = 1;
            @(negedge CLK);
            UPDATE_DR = 0;

            #1;


            check_outputs(8'h3C, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: CLKEN Toggle Verification", test_num);
            reset_dut();
            CLKEN = 1;
            CAPTURE_DR = 0;
            TDI = 1;

            repeat(4) @(negedge CLK);

            CLKEN = 0;
            TDI = 0;
            repeat(4) @(negedge CLK);

            CLKEN = 1;
            TDI = 1;
            repeat(4) @(negedge CLK);
            UPDATE_DR = 1;
            @(negedge CLK);
            UPDATE_DR = 0;

            #1;


            check_outputs(8'hFF, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: CAPTURE_DR Switch Mid-operation", test_num);
            reset_dut();
            CLKEN = 1;

            CAPTURE_DR = 0; TDI = 1;
            repeat(4) @(negedge CLK);

            CAPTURE_DR = 1; DATA_IN = 0;
            repeat(4) @(negedge CLK);
            UPDATE_DR = 1;
            @(negedge CLK);
            UPDATE_DR = 0;


            #1;



            check_outputs(8'h0F, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Mid-shift Async Reset", test_num);
            reset_dut();
            CLKEN = 1; TDI = 1; CAPTURE_DR = 0;
            repeat(4) @(negedge CLK);

            #2 RESET_N = 0;
            #5 RESET_N = 1;

            UPDATE_DR = 1;
            @(negedge CLK);
            UPDATE_DR = 0;

            #1;


            check_outputs(8'h00, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: UPDATE_DR Enable Logic", test_num);
            reset_dut();
            CLKEN = 1; TDI = 1; CAPTURE_DR = 0;
            repeat(8) @(negedge CLK);

            @(negedge CLK);

            #1;


            check_outputs(8'h00, 1'b1);
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
        input [7:0] expected_DATA_OUT;
        input expected_TDO;
        begin
            if (expected_DATA_OUT === (expected_DATA_OUT ^ DATA_OUT ^ expected_DATA_OUT) &&
                expected_TDO === (expected_TDO ^ TDO ^ expected_TDO)) begin
                $display("PASS");
                $display("  Outputs: DATA_OUT=%h, TDO=%b",
                         DATA_OUT, TDO);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: DATA_OUT=%h, TDO=%b",
                         expected_DATA_OUT, expected_TDO);
                $display("  Got:      DATA_OUT=%h, TDO=%b",
                         DATA_OUT, TDO);
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
        $dumpvars(0,CAPTURE_DR, CLK, CLKEN, DATA_IN, RESET_N, TDI, UPDATE_DR, DATA_OUT, TDO);
    end

endmodule
