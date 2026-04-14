`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg parallel_load;
    reg serial_in;
    wire [7:0] register_out;
    wire serial_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .parallel_load(parallel_load),
        .serial_in(serial_in),
        .register_out(register_out),
        .serial_out(serial_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        parallel_load = 1;
        serial_in = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        reset_dut();

        #1;


        check_outputs(8'h00, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        reset_dut();
        parallel_load = 1;
        serial_in = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(8'hFF, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        reset_dut();
        parallel_load = 0;
        serial_in = 1;
        @(posedge clk);
        #1;

        #1;


        check_outputs(8'h01, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        reset_dut();
        parallel_load = 1; serial_in = 1;
        @(posedge clk); #1;
        parallel_load = 0; serial_in = 0;
        @(posedge clk); #1;

        #1;


        check_outputs(8'hFE, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        reset_dut();
        parallel_load = 0;

        serial_in = 1; @(posedge clk); #1;
        serial_in = 1; @(posedge clk); #1;
        serial_in = 0; @(posedge clk); #1;
        serial_in = 1; @(posedge clk); #1;

        #1;


        check_outputs(8'h0D, 1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        reset_dut();
        parallel_load = 0;
        serial_in = 1;

        repeat(8) begin
            @(posedge clk);
            #1;
        end

        #1;


        check_outputs(8'hFF, 1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        reset_dut();
        parallel_load = 0; serial_in = 1; @(posedge clk); #1;
        parallel_load = 1; serial_in = 1; @(posedge clk); #1;
        parallel_load = 0; serial_in = 0; @(posedge clk); #1;
        parallel_load = 0; serial_in = 1; @(posedge clk); #1;

        #1;


        check_outputs(8'hFD, 1'b1);
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
        input [7:0] expected_register_out;
        input expected_serial_out;
        begin
            if (expected_register_out === (expected_register_out ^ register_out ^ expected_register_out) &&
                expected_serial_out === (expected_serial_out ^ serial_out ^ expected_serial_out)) begin
                $display("PASS");
                $display("  Outputs: register_out=%h, serial_out=%b",
                         register_out, serial_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: register_out=%h, serial_out=%b",
                         expected_register_out, expected_serial_out);
                $display("  Got:      register_out=%h, serial_out=%b",
                         register_out, serial_out);
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
        $dumpvars(0,clk, parallel_load, serial_in, register_out, serial_out);
    end

endmodule
