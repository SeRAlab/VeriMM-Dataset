`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg a;
    reg areset;
    reg b;
    reg c;
    reg clk;
    reg d;
    reg ena;
    reg load;
    wire [3:0] final_output;
    wire out_multiplexer;
    wire out_shift_register;
    wire [3:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .areset(areset),
        .b(b),
        .c(c),
        .clk(clk),
        .d(d),
        .ena(ena),
        .load(load),
        .final_output(final_output),
        .out_multiplexer(out_multiplexer),
        .out_shift_register(out_shift_register),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        areset = 0;
        forever #5 areset = ~areset;
    end

        task reset_dut;

    begin
        areset = 1;
        load = 0;
        ena = 0;
        a = 0; b = 0; c = 0; d = 0;
        #12;
        areset = 0;
        #5;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %03d: Asynchronous Reset Check", test_num);
        reset_dut();



        #1;




        check_outputs(final_output, out_multiplexer, 1'b0, 4'b0000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %03d: Parallel Load Check", test_num);
        reset_dut();

        a=1; b=0; c=1; d=1;
        load = 1;
        @(posedge clk);
        #2;



        #1;




        check_outputs(final_output, 1'b1, 1'b1, 4'b1011);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %03d: Shift Logic Check", test_num);
        reset_dut();


        a=1; b=1; c=0; d=0;
        load = 1;
        @(posedge clk);
        #2;


        load = 0;
        ena = 1;


        @(posedge clk);
        #2;
        #1;

        check_outputs(final_output, out_multiplexer, 1'b1, 4'b1000);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %03d: Multi-cycle Shift and MUX Check", test_num);
        reset_dut();


        a=0; b=1; c=1; d=0;
        load = 1;
        @(posedge clk);
        #2;


        load = 0; ena = 1;
        @(posedge clk);
        #2;


        @(posedge clk);
        #2;


        #1;



        check_outputs(final_output, 1'b0, 1'b1, 4'b1000);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %03d: MUX Input Change Check", test_num);
        reset_dut();


        a=0; b=1; c=0; d=0;
        load = 1;
        @(posedge clk);
        #2;

        load = 0; ena = 0;

        if (out_multiplexer === 1'b1) begin

            b = 0;
            #1;
            #1;

            check_outputs(final_output, 1'b0, 1'b0, 4'b0001);
        end else begin
            $display("MUX Selection Error in Step 1");
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
        input [3:0] expected_final_output;
        input expected_out_multiplexer;
        input expected_out_shift_register;
        input [3:0] expected_q;
        begin
            if (expected_final_output === (expected_final_output ^ final_output ^ expected_final_output) &&
                expected_out_multiplexer === (expected_out_multiplexer ^ out_multiplexer ^ expected_out_multiplexer) &&
                expected_out_shift_register === (expected_out_shift_register ^ out_shift_register ^ expected_out_shift_register) &&
                expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: final_output=%h, out_multiplexer=%b, out_shift_register=%b, q=%h",
                         final_output, out_multiplexer, out_shift_register, q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: final_output=%h, out_multiplexer=%b, out_shift_register=%b, q=%h",
                         expected_final_output, expected_out_multiplexer, expected_out_shift_register, expected_q);
                $display("  Got:      final_output=%h, out_multiplexer=%b, out_shift_register=%b, q=%h",
                         final_output, out_multiplexer, out_shift_register, q);
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
        $dumpvars(0,a, areset, b, c, clk, d, ena, load, final_output, out_multiplexer, out_shift_register, q);
    end

endmodule
