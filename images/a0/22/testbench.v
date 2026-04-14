`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [1:0] ctrl;
    reg [3:0] data_in;
    reg load;
    wire [3:0] data_out;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .ctrl(ctrl),
        .data_in(data_in),
        .load(load),
        .data_out(data_out),
        .valid(valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            load = 0;
            ctrl = 0;
            data_in = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Stored Register Value (ctrl=00)", test_num);


            data_in = 4'b1010;
            load = 1;
            @(posedge clk);
            #1;


            load = 0;
            ctrl = 2'b00;
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'b1010, 1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Bitwise Negation of Register (ctrl=01)", test_num);


            data_in = 4'b0011;
            load = 1;
            @(posedge clk);
            #1;


            load = 0;
            ctrl = 2'b01;
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'b1100, 1'b1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Direct Input Data (ctrl=10)", test_num);


            data_in = 4'hD;
            ctrl = 2'b10;
            load = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'hD, 1'b1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Bitwise Negation of Input Data (ctrl=11)", test_num);


            data_in = 4'b0110;
            ctrl = 2'b11;
            load = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'b1001, 1'b1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Register Persistence Check", test_num);


            data_in = 4'h5;
            load = 1;
            @(posedge clk);
            #1;


            load = 0;
            data_in = 4'hF;
            ctrl = 2'b00;
            @(posedge clk);
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'h5, 1'b1);
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
        input [3:0] expected_data_out;
        input expected_valid;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, valid=%b",
                         data_out, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, valid=%b",
                         expected_data_out, expected_valid);
                $display("  Got:      data_out=%h, valid=%b",
                         data_out, valid);
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
        $dumpvars(0,clk, ctrl, data_in, load, data_out, valid);
    end

endmodule
