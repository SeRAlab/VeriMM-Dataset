`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [99:0] data;
    reg [1:0] ena;
    reg [31:0] in;
    reg load;
    wire [31:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data(data),
        .ena(ena),
        .in(in),
        .load(load),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        input [99:0] initial_data;
        input [31:0] initial_in;
        begin
            @(posedge clk);
            #1;
            load = 1;
            data = initial_data;
            in = initial_in;
            ena = 2'b00;


            model_rotator = initial_data;

            model_bytes = {initial_in[7:0], initial_in[15:8], initial_in[23:16], initial_in[31:24]};

            @(posedge clk);
            #1;
            load = 0;
        end
        endtask
    task testcase001;

    begin
        $display("Running Testcase 001: Load and check...");
        reset_dut(100'hA5A5A5A5_5A5A5A5A_FFFFFFFF_12345678, 32'h11223344);
        #1;

        check_outputs(get_expected(model_rotator, model_bytes));
    end
        endtask

    task testcase002;

    begin
        $display("Running Testcase 002: Rotate Left once...");
        reset_dut(100'h80000000_00000000_00000000_00000001, 32'h0);
        ena = 2'b01;
        @(posedge clk);
        #1;
        ena = 2'b00;

        model_rotator = {model_rotator[98:0], model_rotator[99]};
        #1;

        check_outputs(get_expected(model_rotator, model_bytes));
    end
        endtask

    task testcase003;

    begin
        $display("Running Testcase 003: Rotate Right once...");
        reset_dut(100'h00000000_00000000_00000000_00000001, 32'h0);
        ena = 2'b10;
        @(posedge clk);
        #1;
        ena = 2'b00;

        model_rotator = {model_rotator[0], model_rotator[99:1]};
        #1;

        check_outputs(get_expected(model_rotator, model_bytes));
    end
        endtask

    task testcase004;

    begin
        $display("Running Testcase 004: Right rotation wrap-around...");
        reset_dut(100'h00000000_00000000_00000000_00000001, 32'hAABBCCDD);
        ena = 2'b10;
        @(posedge clk);
        #1;
        ena = 2'b00;
        model_rotator = 100'h80000000_00000000_00000000_00000000;
        #1;

        check_outputs(get_expected(model_rotator, model_bytes));
    end
        endtask

    task testcase005;

    integer i;
    begin
        $display("Running Testcase 005: Multiple rotations...");
        reset_dut(100'hFEDCBA98_76543210_FEDCBA98_76543210, 32'h0);
        ena = 2'b01;
        for(i=0; i<4; i=i+1) begin
            @(posedge clk);
            #1;
            model_rotator = {model_rotator[98:0], model_rotator[99]};
        end
        ena = 2'b00;
        #1;

        check_outputs(get_expected(model_rotator, model_bytes));
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
        input [31:0] expected_out;
        begin
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
        $dumpvars(0,clk, data, ena, in, load, out);
    end

endmodule
