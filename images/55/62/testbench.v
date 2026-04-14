`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] data;
    reg dfmt_enable;
    reg dfmt_se;
    reg dfmt_type;
    reg valid;
    wire [15:0] data_out;
    wire valid_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data(data),
        .dfmt_enable(dfmt_enable),
        .dfmt_se(dfmt_se),
        .dfmt_type(dfmt_type),
        .valid(valid),
        .data_out(data_out),
        .valid_out(valid_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            valid <= 0;
            data <= 16'h0;
            dfmt_enable <= 0;
            dfmt_se <= 0;
            dfmt_type <= 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %03d: Bypass Mode", test_num);
            reset_dut();
            valid <= 1;
            data <= 16'hABCD;
            dfmt_enable <= 0;
            dfmt_type <= 1;
            dfmt_se <= 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'hABCD, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %02d: Type 1 Pass-through", test_num);
            reset_dut();
            valid <= 1;
            data <= 16'h55AA;
            dfmt_enable <= 1;
            dfmt_type <= 1;
            dfmt_se <= 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h55AA, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %03d: Type 0 Zero Extension", test_num);
            reset_dut();
            valid <= 1;
            data <= 16'hF801;
            dfmt_enable <= 1;
            dfmt_type <= 0;
            dfmt_se <= 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0801, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %03d: Type 0 Sign Extension (Negative)", test_num);
            reset_dut();
            valid <= 1;
            data <= 16'h0805;
            dfmt_enable <= 1;
            dfmt_type <= 0;
            dfmt_se <= 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'hF805, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %03d: Type 0 Sign Extension (Positive)", test_num);
            reset_dut();
            valid <= 1;
            data <= 16'h07FF;
            dfmt_enable <= 1;
            dfmt_type <= 0;
            dfmt_se <= 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h07FF, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %03d: Valid Low Check", test_num);
            reset_dut();
            valid <= 0;
            data <= 16'h1234;
            dfmt_enable <= 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(data_out, 1'b0);
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
        input [15:0] expected_data_out;
        input expected_valid_out;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_valid_out === (expected_valid_out ^ valid_out ^ expected_valid_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, valid_out=%b",
                         data_out, valid_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, valid_out=%b",
                         expected_data_out, expected_valid_out);
                $display("  Got:      data_out=%h, valid_out=%b",
                         data_out, valid_out);
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
        $dumpvars(0,clk, data, dfmt_enable, dfmt_se, dfmt_type, valid, data_out, valid_out);
    end

endmodule
