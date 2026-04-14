`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg [31:0] DATA;
    reg [39:0] MSG;
    reg RDEN_DATA;
    reg RDEN_MSG;
    reg RST;
    wire [3:0] ERR0;
    wire [3:0] ERR1;
    wire [3:0] ERR2;
    wire [3:0] ERR3;
    wire [3:0] ERR_MSG;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .DATA(DATA),
        .MSG(MSG),
        .RDEN_DATA(RDEN_DATA),
        .RDEN_MSG(RDEN_MSG),
        .RST(RST),
        .ERR0(ERR0),
        .ERR1(ERR1),
        .ERR2(ERR2),
        .ERR3(ERR3),
        .ERR_MSG(ERR_MSG)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            RST = 1;
            RDEN_DATA = 0;
            RDEN_MSG = 0;
            DATA = 32'h0;
            MSG = 40'h0;
            @(posedge CLK);
            #2 RST = 0;
            @(posedge CLK);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();

            #1;


            check_outputs(4'h0, 4'h0, 4'h0, 4'h0, 4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            RDEN_DATA = 1;
            DATA = 32'h00000000;
            @(posedge CLK);

            #1;


            check_outputs(4'h0, 4'h0, 4'h0, 4'h0, 4'h0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            RDEN_DATA = 1;
            DATA = 32'hA5A5_5A5A;
            @(posedge CLK);


            #1;



            check_outputs(ERR0, ERR1, ERR2, ERR3, 4'h0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            RDEN_MSG = 1;
            MSG = 40'hFF_FFFF_FFFF;
            @(posedge CLK);

            #1;


            check_outputs(4'h0, 4'h0, 4'h0, 4'h0, ERR_MSG);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            RDEN_DATA = 1;
            RDEN_MSG = 1;
            DATA = 32'h12345678;
            MSG = 40'h0123456789;
            @(posedge CLK);

            #1;


            check_outputs(ERR0, ERR1, ERR2, ERR3, ERR_MSG);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_dut();
            RDEN_DATA = 0;
            DATA = 32'hFFFFFFFF;
            @(posedge CLK);

            #1;


            check_outputs(4'h0, 4'h0, 4'h0, 4'h0, 4'h0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            reset_dut();
            RDEN_DATA = 1;
            DATA = 32'hAAAAAAAA;
            @(posedge CLK);
            #1;
            DATA = 32'h55555555;
            @(posedge CLK);

            #1;


            check_outputs(ERR0, ERR1, ERR2, ERR3, 4'h0);
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
        input [3:0] expected_ERR0;
        input [3:0] expected_ERR1;
        input [3:0] expected_ERR2;
        input [3:0] expected_ERR3;
        input [3:0] expected_ERR_MSG;
        begin
            if (expected_ERR0 === (expected_ERR0 ^ ERR0 ^ expected_ERR0) &&
                expected_ERR1 === (expected_ERR1 ^ ERR1 ^ expected_ERR1) &&
                expected_ERR2 === (expected_ERR2 ^ ERR2 ^ expected_ERR2) &&
                expected_ERR3 === (expected_ERR3 ^ ERR3 ^ expected_ERR3) &&
                expected_ERR_MSG === (expected_ERR_MSG ^ ERR_MSG ^ expected_ERR_MSG)) begin
                $display("PASS");
                $display("  Outputs: ERR0=%h, ERR1=%h, ERR2=%h, ERR3=%h, ERR_MSG=%h",
                         ERR0, ERR1, ERR2, ERR3, ERR_MSG);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ERR0=%h, ERR1=%h, ERR2=%h, ERR3=%h, ERR_MSG=%h",
                         expected_ERR0, expected_ERR1, expected_ERR2, expected_ERR3, expected_ERR_MSG);
                $display("  Got:      ERR0=%h, ERR1=%h, ERR2=%h, ERR3=%h, ERR_MSG=%h",
                         ERR0, ERR1, ERR2, ERR3, ERR_MSG);
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
        $dumpvars(0,CLK, DATA, MSG, RDEN_DATA, RDEN_MSG, RST, ERR0, ERR1, ERR2, ERR3, ERR_MSG);
    end

endmodule
