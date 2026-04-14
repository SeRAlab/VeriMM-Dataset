`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg BIT;
    reg [2:0] BRANCH_OP;
    reg CLK;
    reg FIn;
    reg [1:0] LOAD;
    reg [1:0] STATIN;
    reg ZIn;
    wire BRANCH;
    wire [1:0] STAT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .BIT(BIT),
        .BRANCH_OP(BRANCH_OP),
        .CLK(CLK),
        .FIn(FIn),
        .LOAD(LOAD),
        .STATIN(STATIN),
        .ZIn(ZIn),
        .BRANCH(BRANCH),
        .STAT(STAT)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            BIT = 0;
            BRANCH_OP = 0;
            FIn = 0;
            LOAD = 0;
            STATIN = 0;
            ZIn = 0;
            @(posedge CLK);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            STATIN = 2'b11;
            LOAD = 2'b01;
            @(posedge CLK);
            #2;

            #1;


            check_outputs(1'b0, 2'b11);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            ZIn = 1'b1;
            FIn = 1'b0;
            LOAD = 2'b10;
            @(posedge CLK);
            #2;

            #1;


            check_outputs(1'b0, 2'b10);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;

            STATIN = 2'b10;
            LOAD = 2'b01;
            @(posedge CLK);
            #2;

            LOAD = 2'b00;
            STATIN = 2'b01;
            @(posedge CLK);
            #2;

            #1;


            check_outputs(1'b0, 2'b10);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            BRANCH_OP = 3'b001;
            #2;

            #1;


            check_outputs(1'b1, 2'b00);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;

            STATIN = 2'b10;
            LOAD = 2'b01;
            @(posedge CLK);
            #2;
            BRANCH_OP = 3'b010;
            #2;
            #1;

            check_outputs(1'b1, 2'b10);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;

            STATIN = 2'b01;
            LOAD = 2'b01;
            @(posedge CLK);
            #2;
            BRANCH_OP = 3'b010;
            #2;
            #1;

            check_outputs(1'b0, 2'b01);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;
            BIT = 1'b1;
            LOAD = 2'b11;
            @(posedge CLK);
            #2;

            #1;


            check_outputs(1'b0, 2'b10);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            test_num = 8;

            STATIN = 2'b01;
            LOAD = 2'b01;
            @(posedge CLK);
            #2;
            BRANCH_OP = 3'b100;
            #2;
            #1;

            check_outputs(1'b1, 2'b01);
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
        input expected_BRANCH;
        input [1:0] expected_STAT;
        begin
            if (expected_BRANCH === (expected_BRANCH ^ BRANCH ^ expected_BRANCH) &&
                expected_STAT === (expected_STAT ^ STAT ^ expected_STAT)) begin
                $display("PASS");
                $display("  Outputs: BRANCH=%b, STAT=%h",
                         BRANCH, STAT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: BRANCH=%b, STAT=%h",
                         expected_BRANCH, expected_STAT);
                $display("  Got:      BRANCH=%b, STAT=%h",
                         BRANCH, STAT);
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
        $dumpvars(0,BIT, BRANCH_OP, CLK, FIn, LOAD, STATIN, ZIn, BRANCH, STAT);
    end

endmodule
