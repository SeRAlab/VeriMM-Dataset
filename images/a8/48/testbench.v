`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] addr;
    reg clk;
    reg [7:0] data_in;
    reg enable;
    reg reset;
    wire [7:0] data_out;
    wire done;
    wire error;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr(addr),
        .clk(clk),
        .data_in(data_in),
        .enable(enable),
        .reset(reset),
        .data_out(data_out),
        .done(done),
        .error(error),
        .valid(valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            enable = 0;
            addr = 0;
            data_in = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();


            #1;



            check_outputs(8'h00, 0, 0, 0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            enable = 1;
            addr = 4'h0;
            data_in = 8'hAA;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'hAA, 0, 0, 1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            enable = 1;
            addr = 4'h1;
            data_in = 8'hBB;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'hBB, 1, 0, 0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            enable = 1;
            addr = 4'h2;
            data_in = 8'hCC;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'hCC, 0, 1, 0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            enable = 1;
            addr = 4'h3;
            data_in = 8'hDD;
            @(posedge clk);
            #2;

            #1;


            check_outputs(8'hDD, 1, 0, 1);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            enable = 0;
            addr = 4'h0;
            data_in = 8'hFF;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'h00, 0, 0, 0);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            enable = 1;
            addr = 4'h7;
            data_in = 8'h55;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'h55, 0, 0, 0);
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
        input [7:0] expected_data_out;
        input expected_done;
        input expected_error;
        input expected_valid;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_done === (expected_done ^ done ^ expected_done) &&
                expected_error === (expected_error ^ error ^ expected_error) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, done=%b, error=%b, valid=%b",
                         data_out, done, error, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, done=%b, error=%b, valid=%b",
                         expected_data_out, expected_done, expected_error, expected_valid);
                $display("  Got:      data_out=%h, done=%b, error=%b, valid=%b",
                         data_out, done, error, valid);
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
        $dumpvars(0,addr, clk, data_in, enable, reset, data_out, done, error, valid);
    end

endmodule
