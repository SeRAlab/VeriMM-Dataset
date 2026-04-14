`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg advance_i;
    reg align_i;
    reg break_i;
    reg clk;
    reg direction_i;
    reg enable_i;
    reg reset_i;
    wire [3:0] state_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .advance_i(advance_i),
        .align_i(align_i),
        .break_i(break_i),
        .clk(clk),
        .direction_i(direction_i),
        .enable_i(enable_i),
        .reset_i(reset_i),
        .state_o(state_o)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset_i = 1;
            advance_i = 0;
            align_i = 0;
            break_i = 0;
            direction_i = 1;
            enable_i = 1;
            @(posedge clk);
            #1;
            reset_i = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();

            #1;


            check_outputs(4'h0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            advance_i = 1;
            direction_i = 1;
            enable_i = 1;
            @(posedge clk);
            #1;
            advance_i = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'h1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            direction_i = 1;
            enable_i = 1;
            repeat (3) begin
                advance_i = 1;
                @(posedge clk);
                #1;
                advance_i = 0;
                @(posedge clk);
                #1;
            end
            #1;

            check_outputs(4'h3);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            direction_i = 0;
            advance_i = 1;
            enable_i = 1;
            @(posedge clk);
            #1;
            advance_i = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'h7);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            enable_i = 0;
            advance_i = 1;
            direction_i = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();

            enable_i = 1;
            direction_i = 1;
            repeat(3) begin
                advance_i = 1; @(posedge clk); #1;
                advance_i = 0; @(posedge clk); #1;
            end

            align_i = 1;
            @(posedge clk);
            #1;
            align_i = 0;

            #1;


            check_outputs(4'h0);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            break_i = 1;
            @(posedge clk);
            #1;


            #1;



            check_outputs(state_o);
            break_i = 0;
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
        input [3:0] expected_state_o;
        begin
            if (expected_state_o === (expected_state_o ^ state_o ^ expected_state_o)) begin
                $display("PASS");
                $display("  Outputs: state_o=%h",
                         state_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: state_o=%h",
                         expected_state_o);
                $display("  Got:      state_o=%h",
                         state_o);
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
        $dumpvars(0,advance_i, align_i, break_i, clk, direction_i, enable_i, reset_i, state_o);
    end

endmodule
