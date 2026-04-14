`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk_in;
    reg ex_freeze;
    reg [31:0] instruction_opcode;
    reg reset;
    wire data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk_in(clk_in),
        .ex_freeze(ex_freeze),
        .instruction_opcode(instruction_opcode),
        .reset(reset),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk_in = 0;
        forever #5 clk_in = ~clk_in;
    end

        task reset_dut;

        begin
            @(negedge clk_in);
            reset = 1;
            ex_freeze = 0;
            instruction_opcode = 32'h0;
            #15;
            reset = 0;
            @(posedge clk_in);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Reset and Idle", test_num);
            reset_dut();
            instruction_opcode = 32'h0;
            ex_freeze = 0;
            repeat(2) @(posedge clk_in);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Basic Opcode Transition", test_num);
            reset_dut();
            instruction_opcode = 32'h00000033;
            ex_freeze = 0;
            @(posedge clk_in);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Freeze Signal Inhibition", test_num);
            reset_dut();
            ex_freeze = 1;
            instruction_opcode = 32'h00000033;
            repeat(2) @(posedge clk_in);
            #1;


            #1;



            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Unfreeze Transition", test_num);
            reset_dut();
            ex_freeze = 1;
            instruction_opcode = 32'h00000033;
            @(posedge clk_in);
            ex_freeze = 0;
            @(posedge clk_in);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Branch Opcode", test_num);
            reset_dut();
            instruction_opcode = 32'h0000006F;
            ex_freeze = 0;
            repeat(2) @(posedge clk_in);
            #1;
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
        input expected_data_out;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%b",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%b",
                         expected_data_out);
                $display("  Got:      data_out=%b",
                         data_out);
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
        $dumpvars(0,clk_in, ex_freeze, instruction_opcode, reset, data_out);
    end

endmodule
