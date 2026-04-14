`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [99:0] data;
    reg [1:0] ena;
    reg load;
    reg reset_n;
    reg select;
    wire [5:0] counter_out;
    wire [99:0] functional_out;
    wire [99:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data(data),
        .ena(ena),
        .load(load),
        .reset_n(reset_n),
        .select(select),
        .counter_out(counter_out),
        .functional_out(functional_out),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset_n = 0;
        load = 0;
        ena = 2'b00;
        data = 0;
        select = 0;
        @(posedge clk);
        #1 reset_n = 1;
    end
        endtask
    task wait_cycles;

        input integer n;
        begin
            repeat(n) @(posedge clk);
            #1;
        end
        endtask

    task testcase001;

    begin
        test_num = 1;
        reset_dut();

        data = 100'hA5A5A5A5A5A5A5A5A5A5A5A5A;
        load = 1;
        wait_cycles(1);
        load = 0;


        #1;



        check_outputs(6'h1A, 100'hA5A5A5A5A5A5A5A5A5A5A5A5A, 100'hA5A5A5A5A5A5A5A5A5A5A5A5A);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        reset_dut();

        data = 100'h1;
        load = 1;
        wait_cycles(1);
        load = 0;

        ena = 2'b01;
        wait_cycles(1);
        ena = 2'b00;


        #1;



        check_outputs(6'h00, 100'h8000000000000000000000000, 100'h8000000000000000000000000);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        reset_dut();

        ena = 2'b10;
        wait_cycles(1);


        wait_cycles(1);


        ena = 2'b00;
        #1;

        check_outputs(6'h30, 100'h0, 100'h0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        reset_dut();

        data = 100'hF0F0F0;
        load = 1;
        wait_cycles(1);
        load = 0;

        select = 1;




        data = 100'hAAAA00;
        load = 1;
        wait_cycles(1);
        load = 0;



        ena = 2'b10;
        wait_cycles(1);
        ena = 2'b00;


        #1;



        check_outputs(6'h20, 100'hAAAA20, 100'hAAAA00);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        reset_dut();

        data = 100'h5;
        load = 1;
        wait_cycles(1);
        load = 0;

        ena = 2'b11;
        select = 1;
        wait_cycles(2);







        if (q != 100'h5 && counter_out != 6'h05) begin
            $display("PASS: Logic transitioned from initial load");
            pass_count = pass_count + 1;
        end else begin
            $display("FAIL: Logic remained static despite enable");
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
        input [5:0] expected_counter_out;
        input [99:0] expected_functional_out;
        input [99:0] expected_q;
        begin
            if (expected_counter_out === (expected_counter_out ^ counter_out ^ expected_counter_out) &&
                expected_functional_out === (expected_functional_out ^ functional_out ^ expected_functional_out) &&
                expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: counter_out=%h, functional_out=%h, q=%h",
                         counter_out, functional_out, q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: counter_out=%h, functional_out=%h, q=%h",
                         expected_counter_out, expected_functional_out, expected_q);
                $display("  Got:      counter_out=%h, functional_out=%h, q=%h",
                         counter_out, functional_out, q);
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
        $dumpvars(0,clk, data, ena, load, reset_n, select, counter_out, functional_out, q);
    end

endmodule
