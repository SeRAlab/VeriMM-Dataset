`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg [15:0] config_in;
    reg config_in_valid;
    reg enable;
    reg reset;
    wire [15:0] config_out;
    wire config_out_valid;
    wire [31:0] rand_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .config_in(config_in),
        .config_in_valid(config_in_valid),
        .enable(enable),
        .reset(reset),
        .config_out(config_out),
        .config_out_valid(config_out_valid),
        .rand_out(rand_out)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

    begin
        reset = 1;
        enable = 0;
        config_in = 16'h0;
        config_in_valid = 0;
        @(posedge clock);
        #1;
        reset = 0;
        @(posedge clock);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Reset State", test_num);
        reset_dut();




        #1;





        check_outputs(16'h0000, 1'b0, 32'h00000000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Single Step Enable", test_num);
        reset_dut();

        enable = 1;
        @(posedge clock);
        #1;
        enable = 0;
        @(posedge clock);
        #1;



        #1;




        check_outputs(16'h0000, 1'b0, rand_out);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Configuration Input", test_num);
        reset_dut();

        config_in = 16'hACE0;
        config_in_valid = 1;
        @(posedge clock);
        #1;
        config_in_valid = 0;
        @(posedge clock);
        #1;



        #1;




        check_outputs(config_out, config_out_valid, rand_out);
    end
        endtask

    task testcase004;

    reg [31:0] first_val;
    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Sustained Enable", test_num);
        reset_dut();

        enable = 1;
        @(posedge clock);
        #1;
        first_val = rand_out;

        repeat(5) @(posedge clock);
        #1;


        if (rand_out != first_val) begin
             $display("  Success: rand_out changed from %h to %h", first_val, rand_out);
             #1;

             check_outputs(config_out, config_out_valid, rand_out);
        end else begin
             $display("  Failure: rand_out stuck at %h", first_val);
             fail_count = fail_count + 1;
        end
    end
        endtask

    task testcase005;

    reg [31:0] captured_val;
    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Enable Freeze", test_num);
        reset_dut();

        enable = 1;
        repeat(3) @(posedge clock);
        #1;
        enable = 0;
        captured_val = rand_out;

        repeat(3) @(posedge clock);
        #1;


        #1;



        check_outputs(config_out, config_out_valid, captured_val);
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
        input [15:0] expected_config_out;
        input expected_config_out_valid;
        input [31:0] expected_rand_out;
        begin
            if (expected_config_out === (expected_config_out ^ config_out ^ expected_config_out) &&
                expected_config_out_valid === (expected_config_out_valid ^ config_out_valid ^ expected_config_out_valid) &&
                expected_rand_out === (expected_rand_out ^ rand_out ^ expected_rand_out)) begin
                $display("PASS");
                $display("  Outputs: config_out=%h, config_out_valid=%b, rand_out=%h",
                         config_out, config_out_valid, rand_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: config_out=%h, config_out_valid=%b, rand_out=%h",
                         expected_config_out, expected_config_out_valid, expected_rand_out);
                $display("  Got:      config_out=%h, config_out_valid=%b, rand_out=%h",
                         config_out, config_out_valid, rand_out);
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
        $dumpvars(0,clock, config_in, config_in_valid, enable, reset, config_out, config_out_valid, rand_out);
    end

endmodule
