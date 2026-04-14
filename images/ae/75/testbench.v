`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data;
    reg ena;
    reg rst_clk;
    wire [15:0] op_ir;
    wire [1:0] state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data(data),
        .ena(ena),
        .rst_clk(rst_clk),
        .op_ir(op_ir),
        .state(state)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_clk = 1;
            ena = 0;
            data = 8'h00;
            @(posedge clk);
            #2 rst_clk = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();


            ena = 1;
            data = 8'h12;
            @(posedge clk);
            #2;


            data = 8'h34;
            @(posedge clk);
            #2;


            #1;



            check_outputs(16'h1234, 2'b00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();

            ena = 1;
            data = 8'hAB;
            @(posedge clk);
            #2;

            data = 8'hCD;
            @(posedge clk);
            #2;

            #1;


            check_outputs(16'hABCD, 2'b00);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();

            ena = 0;
            data = 8'hFF;
            @(posedge clk);
            @(posedge clk);
            #2;


            #1;



            check_outputs(16'h0000, 2'b00);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();


            ena = 1;
            data = 8'h55;
            @(posedge clk);
            #2;


            ena = 0;
            @(posedge clk);
            #2;


            ena = 1;
            data = 8'hAA;
            @(posedge clk);
            #2;

            data = 8'hBB;
            @(posedge clk);
            #2;

            #1;


            check_outputs(16'hAABB, 2'b00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();

            ena = 1;
            data = 8'h11;
            @(posedge clk);
            #2;


            rst_clk = 1;
            #3;


            #1;



            check_outputs(16'h1100, 2'b00);


            rst_clk = 0;
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_dut();

            ena = 1;

            data = 8'hDE; @(posedge clk); #1;
            data = 8'hAD; @(posedge clk); #1;

            data = 8'hBE; @(posedge clk); #1;
            data = 8'hEF; @(posedge clk); #2;

            #1;


            check_outputs(16'hBEEF, 2'b00);
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
        input [15:0] expected_op_ir;
        input [1:0] expected_state;
        begin
            if (expected_op_ir === (expected_op_ir ^ op_ir ^ expected_op_ir) &&
                expected_state === (expected_state ^ state ^ expected_state)) begin
                $display("PASS");
                $display("  Outputs: op_ir=%h, state=%h",
                         op_ir, state);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: op_ir=%h, state=%h",
                         expected_op_ir, expected_state);
                $display("  Got:      op_ir=%h, state=%h",
                         op_ir, state);
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
        $dumpvars(0,clk, data, ena, rst_clk, op_ir, state);
    end

endmodule
