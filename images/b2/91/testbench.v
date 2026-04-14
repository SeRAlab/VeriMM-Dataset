`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [99:0] data;
    reg [1:0] ena;
    reg load;
    reg [2:0] vec;
    wire o0;
    wire o1;
    wire o2;
    wire [2:0] outv;
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
        .vec(vec),
        .o0(o0),
        .o1(o1),
        .o2(o2),
        .outv(outv),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        load = 1;
        ena = 2'b00;
        data = 100'b0;
        vec = 3'b000;
        @(posedge clk);
        #2 load = 0;
    end
    endtask
    task testcase001;

    begin
        test_num = 1;
        reset_dut();

        data = 100'hFEDCBA9876543210123456789;
        vec = 3'b101;
        load = 1;
        ena = 2'b00;
        @(posedge clk);
        #2;
        load = 0;

        #1;


        check_outputs(1, 0, 1, 3'b101, 100'hFEDCBA987654321012345678D);
    end
    endtask

    task testcase002;

    begin
        test_num = 2;
        reset_dut();
        data = 100'h1;
        vec = 3'b000;
        load = 1;
        @(posedge clk);
        #2;
        load = 0;
        ena = 2'b10;
        @(posedge clk);
        #2;

        #1;


        check_outputs(0, 0, 0, 3'b000, 100'h2);
    end
    endtask

    task testcase003;

    begin
        test_num = 3;
        reset_dut();
        data = 100'h1;
        vec = 3'b000;
        load = 1;
        @(posedge clk);
        #2;
        load = 0;
        ena = 2'b01;
        @(posedge clk);
        #2;


        #1;



        check_outputs(0, 0, 0, 3'b000, 100'h8000000000000000000000000);
    end
    endtask

    task testcase004;

    begin
        test_num = 4;
        reset_dut();
        data = 100'h0;
        vec = 3'b100;
        load = 1;
        @(posedge clk);
        #2;

        load = 0;
        ena = 2'b10;
        vec = 3'b001;
        @(posedge clk);
        #2;



        #1;




        check_outputs(1, 0, 0, 3'b001, 100'h9);
    end
    endtask

    task testcase005;

    begin
        test_num = 5;
        reset_dut();
        data = 100'h8000000000000000000000000;
        vec = 3'b000;
        load = 1;
        @(posedge clk);
        #2;
        load = 0;
        ena = 2'b10;
        @(posedge clk);
        #2;

        #1;


        check_outputs(0, 0, 0, 3'b000, 100'h1);
    end
    endtask

    task testcase006;

    begin
        test_num = 6;
        reset_dut();
        data = 100'hABCDEABCDEABCDEABCDEABCDE;
        vec = 3'b000;
        load = 1;
        @(posedge clk);
        #2;
        load = 0;
        ena = 2'b11;
        @(posedge clk);
        #2;
        #1;

        check_outputs(0, 0, 0, 3'b000, 100'hABCDEABCDEABCDEABCDEABCDE);

        ena = 2'b00;
        @(posedge clk);
        #2;
        #1;

        check_outputs(0, 0, 0, 3'b000, 100'hABCDEABCDEABCDEABCDEABCDE);
    end
    endtask

    task testcase007;

    begin
        test_num = 7;
        reset_dut();
        data = 100'h1;
        vec = 3'b000;
        load = 1;
        @(posedge clk);
        #2;
        load = 0;
        ena = 2'b10;
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        #2;
        #1;

        check_outputs(0, 0, 0, 3'b000, 100'h8);
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
        input expected_o0;
        input expected_o1;
        input expected_o2;
        input [2:0] expected_outv;
        input [99:0] expected_q;
        begin
            if (expected_o0 === (expected_o0 ^ o0 ^ expected_o0) &&
                expected_o1 === (expected_o1 ^ o1 ^ expected_o1) &&
                expected_o2 === (expected_o2 ^ o2 ^ expected_o2) &&
                expected_outv === (expected_outv ^ outv ^ expected_outv) &&
                expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: o0=%b, o1=%b, o2=%b, outv=%h, q=%h",
                         o0, o1, o2, outv, q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o0=%b, o1=%b, o2=%b, outv=%h, q=%h",
                         expected_o0, expected_o1, expected_o2, expected_outv, expected_q);
                $display("  Got:      o0=%b, o1=%b, o2=%b, outv=%h, q=%h",
                         o0, o1, o2, outv, q);
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
        $dumpvars(0,clk, data, ena, load, vec, o0, o1, o2, outv, q);
    end

endmodule
