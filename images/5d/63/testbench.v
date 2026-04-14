`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in_1;
    reg [7:0] data_in_2;
    reg load;
    reg reset;
    wire [7:0] functional_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_in_1(data_in_1),
        .data_in_2(data_in_2),
        .load(load),
        .reset(reset),
        .functional_output(functional_output)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        load = 0;
        reset = 1;
        data_in_1 = 8'h00;
        data_in_2 = 8'h00;
        @(posedge clk);
        #1;
        reset = 0;
        load = 0;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Basic Load and OR Check", test_num);
        reset_dut();


        data_in_1 = 8'hAA;
        data_in_2 = 8'h55;
        load = 1;
        reset = 1;
        @(posedge clk);
        #1;


        #1;



        check_outputs(8'hFF);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Single Left Shift", test_num);
        reset_dut();


        data_in_1 = 8'h55;
        data_in_2 = 8'hAA;
        load = 1;
        reset = 1;
        @(posedge clk);
        #1;


        load = 0;
        reset = 0;
        @(posedge clk);
        #1;




        #1;





        check_outputs(8'hFE);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Multiple Shifts (4 Cycles)", test_num);
        reset_dut();

        data_in_1 = 8'h01;
        data_in_2 = 8'h02;
        load = 1;
        reset = 1;
        @(posedge clk);
        #1;

        load = 0;
        reset = 0;
        repeat(4) @(posedge clk);
        #1;




        #1;





        check_outputs(8'h30);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Load Reg1 while Reg2 shifts", test_num);
        reset_dut();


        data_in_2 = 8'hFF;
        reset = 1;
        load = 0;
        @(posedge clk);
        #1;


        reset = 0;
        load = 1;
        data_in_1 = 8'hA5;
        @(posedge clk);
        #1;




        #1;





        check_outputs(8'hFF);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Shift All Bits Out", test_num);
        reset_dut();

        data_in_1 = 8'hFF;
        data_in_2 = 8'hFF;
        load = 1;
        reset = 1;
        @(posedge clk);
        #1;

        load = 0;
        reset = 0;
        repeat(8) @(posedge clk);
        #1;


        #1;



        check_outputs(8'h00);
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
        input [7:0] expected_functional_output;
        begin
            if (expected_functional_output === (expected_functional_output ^ functional_output ^ expected_functional_output)) begin
                $display("PASS");
                $display("  Outputs: functional_output=%h",
                         functional_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: functional_output=%h",
                         expected_functional_output);
                $display("  Got:      functional_output=%h",
                         functional_output);
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
        $dumpvars(0,clk, data_in_1, data_in_2, load, reset, functional_output);
    end

endmodule
