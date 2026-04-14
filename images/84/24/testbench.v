`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg i_clk;
    reg [31:0] i_data;
    reg i_pop;
    reg i_push;
    reg i_reset;
    wire [31:0] o_data;
    wire o_empty;
    wire o_full;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .i_clk(i_clk),
        .i_data(i_data),
        .i_pop(i_pop),
        .i_push(i_push),
        .i_reset(i_reset),
        .o_data(o_data),
        .o_empty(o_empty),
        .o_full(o_full)
    );

    // Clock generation (10ns period)
    initial begin
        i_clk = 0;
        forever #5 i_clk = ~i_clk;
    end

        task reset_dut;

        begin
            i_reset = 1;
            i_push = 0;
            i_pop = 0;
            i_data = 0;
            #15;
            i_reset = 0;
            @(posedge i_clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            #1;


            check_outputs(o_data, 1, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            i_push = 1;
            i_data = 32'hABCDE001;
            @(posedge i_clk);
            #1;
            i_push = 0;

            #1;


            check_outputs(32'hABCDE001, 0, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();

            i_push = 1;
            i_data = 32'h12345678;
            @(posedge i_clk);
            #1;
            i_push = 0;

            i_pop = 1;
            @(posedge i_clk);
            #1;
            i_pop = 0;

            #1;


            check_outputs(32'h12345678, 1, 0);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = 4;
            reset_dut();
            for (i = 0; i < 16; i = i + 1) begin
                i_push = 1;
                i_data = i;
                @(posedge i_clk);
                #1;
            end
            i_push = 0;

            #1;


            check_outputs(o_data, 0, 1);
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = 5;
            reset_dut();

            for (i = 0; i < 16; i = i + 1) begin
                i_push = 1;
                i_data = i + 100;
                @(posedge i_clk);
                #1;
            end
            i_push = 0;

            for (i = 0; i < 16; i = i + 1) begin
                i_pop = 1;
                @(posedge i_clk);
                #1;
            end
            i_pop = 0;

            #1;


            check_outputs(115, 1, 0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();

            i_push = 1; i_data = 32'hFEEDFACE;
            @(posedge i_clk); #1;
            i_push = 1; i_data = 32'hCAFEBABE;
            @(posedge i_clk); #1;
            i_push = 0;


            i_pop = 1;

            @(posedge i_clk); #1;

            i_pop = 0;
            #1;

            check_outputs(32'hCAFEBABE, 0, 0);
        end
        endtask

    task testcase007;

        integer i;
        begin
            test_num = 7;
            reset_dut();
            for (i = 0; i <= 16; i = i + 1) begin
                i_push = 1;
                i_data = i;
                @(posedge i_clk);
                #1;
            end
            i_push = 0;

            #1;


            check_outputs(o_data, 0, 1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            reset_dut();

            i_push = 1; i_data = 32'h1111;
            @(posedge i_clk); #1;

            i_push = 1; i_data = 32'h2222;
            i_pop = 1;
            @(posedge i_clk); #1;
            i_push = 0; i_pop = 0;

            #1;


            check_outputs(32'h2222, 0, 0);
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
        input [31:0] expected_o_data;
        input expected_o_empty;
        input expected_o_full;
        begin
            if (expected_o_data === (expected_o_data ^ o_data ^ expected_o_data) &&
                expected_o_empty === (expected_o_empty ^ o_empty ^ expected_o_empty) &&
                expected_o_full === (expected_o_full ^ o_full ^ expected_o_full)) begin
                $display("PASS");
                $display("  Outputs: o_data=%h, o_empty=%b, o_full=%b",
                         o_data, o_empty, o_full);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o_data=%h, o_empty=%b, o_full=%b",
                         expected_o_data, expected_o_empty, expected_o_full);
                $display("  Got:      o_data=%h, o_empty=%b, o_full=%b",
                         o_data, o_empty, o_full);
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
        $dumpvars(0,i_clk, i_data, i_pop, i_push, i_reset, o_data, o_empty, o_full);
    end

endmodule
