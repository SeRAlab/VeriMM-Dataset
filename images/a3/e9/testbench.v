`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [5:0] op;
    reg reset;
    wire stall;
    wire stall_pm;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .op(op),
        .reset(reset),
        .stall(stall),
        .stall_pm(stall_pm)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            op = 6'b000000;
            @(posedge clk);
            #2;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: NOP/Default Operation", test_num);
            reset_dut();

            op = 6'h00;
            @(posedge clk);
            #2;


            #1;



            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: LOAD Instruction Stall", test_num);
            reset_dut();

            op = 6'h03;
            @(posedge clk);
            #2;


            #1;



            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: JUMP Instruction Stall", test_num);
            reset_dut();

            op = 6'h02;
            @(posedge clk);
            #2;


            #1;



            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: HALT Instruction Stall", test_num);
            reset_dut();

            op = 6'h3F;
            @(posedge clk);
            #2;


            #1;



            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Reset Priority over Opcode", test_num);
            reset_dut();

            op = 6'h3F;
            @(posedge clk);
            #1;
            reset = 1;
            @(posedge clk);
            #2;


            #1;



            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Transition Stall to NOP", test_num);
            reset_dut();

            op = 6'h03;
            @(posedge clk);
            #2;
            op = 6'h00;
            @(posedge clk);
            #2;


            #1;



            check_outputs(1'b0, 1'b0);
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
        input expected_stall;
        input expected_stall_pm;
        begin
            if (expected_stall === (expected_stall ^ stall ^ expected_stall) &&
                expected_stall_pm === (expected_stall_pm ^ stall_pm ^ expected_stall_pm)) begin
                $display("PASS");
                $display("  Outputs: stall=%b, stall_pm=%b",
                         stall, stall_pm);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: stall=%b, stall_pm=%b",
                         expected_stall, expected_stall_pm);
                $display("  Got:      stall=%b, stall_pm=%b",
                         stall, stall_pm);
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
        $dumpvars(0,clk, op, reset, stall, stall_pm);
    end

endmodule
