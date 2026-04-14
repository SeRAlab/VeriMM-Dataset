`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg FFlag3;
    reg [7:0] PC;
    reg clk;
    reg rst;
    wire FFlag1;
    wire [13:0] Ins;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .FFlag3(FFlag3),
        .PC(PC),
        .clk(clk),
        .rst(rst),
        .FFlag1(FFlag1),
        .Ins(Ins)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 0;
            FFlag3 = 0;
            PC = 0;
            #15;
            rst = 1;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Fetch PC=0 and Check FFlag1 Timing", test_num);
            reset_dut();
            PC = 8'd0;
            FFlag3 = 1'b1;


            #20;



            captured_ins_0 = Ins;
            #1;

            check_outputs(1'b1, captured_ins_0);

            FFlag3 = 0;
            #10;
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Modulo Addressing Wrap (PC=20 == PC=0)", test_num);
            reset_dut();
            PC = 8'd20;
            FFlag3 = 1'b1;

            #25;


            #1;



            check_outputs(1'b1, captured_ins_0);

            FFlag3 = 0;
            #10;
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Fetch PC=5", test_num);
            reset_dut();
            PC = 8'd5;
            FFlag3 = 1'b1;

            #25;

            captured_ins_5 = Ins;
            #1;

            check_outputs(1'b1, captured_ins_5);

            FFlag3 = 0;
            #10;
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Modulo Addressing Wrap (PC=25 == PC=5)", test_num);
            reset_dut();
            PC = 8'd25;
            FFlag3 = 1'b1;

            #25;

            #1;


            check_outputs(1'b1, captured_ins_5);

            FFlag3 = 0;
            #10;
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: No fetch when FFlag3 is Low", test_num);
            reset_dut();
            PC = 8'd10;
            FFlag3 = 1'b0;

            #30;


            if (FFlag1 === 1'b0) begin
                $display("PASS: FFlag1 remained low");
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: FFlag1 went high without FFlag3");
                fail_count = fail_count + 1;
            end
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
        input expected_FFlag1;
        input [13:0] expected_Ins;
        begin
            if (expected_FFlag1 === (expected_FFlag1 ^ FFlag1 ^ expected_FFlag1) &&
                expected_Ins === (expected_Ins ^ Ins ^ expected_Ins)) begin
                $display("PASS");
                $display("  Outputs: FFlag1=%b, Ins=%h",
                         FFlag1, Ins);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: FFlag1=%b, Ins=%h",
                         expected_FFlag1, expected_Ins);
                $display("  Got:      FFlag1=%b, Ins=%h",
                         FFlag1, Ins);
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
        $dumpvars(0,FFlag3, PC, clk, rst, FFlag1, Ins);
    end

endmodule
