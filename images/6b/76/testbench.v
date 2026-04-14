`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] PC;
    reg clk;
    wire [31:0] inst;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .PC(PC),
        .clk(clk),
        .inst(inst)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            PC = 32'h0;

            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            PC = 32'd0;

            @(posedge clk);
            #1;


            #1;



            check_outputs(32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();

            PC = 32'd1;
            @(posedge clk);
            #1;


            #1;



            check_outputs(32'h00000001);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();

            PC = 32'd2;
            @(posedge clk);
            #1;


            #1;



            check_outputs(32'h00000002);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();

            PC = 32'd3;
            @(posedge clk);
            #1;


            #1;



            check_outputs(32'h00000003);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();

            PC = 32'hF;
            @(posedge clk);
            #1;


            #1;



            check_outputs(32'h0000000F);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();

            PC = 32'hFF;
            @(posedge clk);
            #1;


            #1;



            check_outputs(32'h000000FF);
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
        input [31:0] expected_inst;
        begin
            if (expected_inst === (expected_inst ^ inst ^ expected_inst)) begin
                $display("PASS");
                $display("  Outputs: inst=%h",
                         inst);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: inst=%h",
                         expected_inst);
                $display("  Got:      inst=%h",
                         inst);
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
        $dumpvars(0,PC, clk, inst);
    end

endmodule
