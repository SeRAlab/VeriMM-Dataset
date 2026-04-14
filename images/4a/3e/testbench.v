`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg counter_enable;
    reg [3:0] reg_data_in;
    reg reg_load;
    reg reset;
    wire [7:0] output_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .counter_enable(counter_enable),
        .reg_data_in(reg_data_in),
        .reg_load(reg_load),
        .reset(reset),
        .output_data(output_data)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        reg_load = 0;
        counter_enable = 0;
        reg_data_in = 4'b0;
        @(posedge clk);
        #2;
        reset = 0;
        @(posedge clk);
        #2;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: System Reset", test_num);
        reset_dut();
        #1;

        check_outputs(8'hFF);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Load Register (Data 0xA)", test_num);
        reset_dut();
        reg_data_in = 4'hA;
        reg_load = 1;
        @(posedge clk);
        #2;
        reg_load = 0;
        #1;

        check_outputs(8'h5F);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Counter Increment (Value 5)", test_num);
        reset_dut();
        counter_enable = 1;
        repeat(5) @(posedge clk);
        #2;
        counter_enable = 0;
        #1;

        check_outputs(8'hFA);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Simultaneous Load and Count", test_num);
        reset_dut();
        reg_data_in = 4'h3;
        reg_load = 1;
        counter_enable = 1;
        repeat(2) @(posedge clk);
        #2;
        reg_load = 0;
        counter_enable = 0;
        #1;

        check_outputs(8'hCD);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Counter Overflow (Wrap to 1)", test_num);
        reset_dut();
        counter_enable = 1;
        repeat(17) @(posedge clk);
        #2;
        counter_enable = 0;
        #1;

        check_outputs(8'hFE);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Register Overwrite", test_num);
        reset_dut();
        reg_load = 1;
        reg_data_in = 4'hF;
        @(posedge clk);
        #2;
        reg_data_in = 4'h0;
        @(posedge clk);
        #2;
        reg_load = 0;
        #1;

        check_outputs(8'hFF);
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
        input [7:0] expected_output_data;
        begin
            if (expected_output_data === (expected_output_data ^ output_data ^ expected_output_data)) begin
                $display("PASS");
                $display("  Outputs: output_data=%h",
                         output_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: output_data=%h",
                         expected_output_data);
                $display("  Got:      output_data=%h",
                         output_data);
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
        $dumpvars(0,clk, counter_enable, reg_data_in, reg_load, reset, output_data);
    end

endmodule
