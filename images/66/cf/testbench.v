`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] data_in;
    reg rst;
    reg [1:0] shift_amount;
    wire [3:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_in(data_in),
        .rst(rst),
        .shift_amount(shift_amount),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            data_in = 0;
            shift_amount = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            data_in = 4'sb0011;
            shift_amount = 2'b00;
            @(posedge clk);
            #1 #1;
 check_outputs(4'sb0011);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            data_in = 4'sb0001;
            shift_amount = 2'b01;
            @(posedge clk);
            #1 #1;
 check_outputs(4'sb0010);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            data_in = 4'sb0001;
            shift_amount = 2'b10;
            @(posedge clk);
            #1 #1;
 check_outputs(4'sb0100);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            data_in = 4'sb0001;
            shift_amount = 2'b11;
            @(posedge clk);
            #1 #1;
 check_outputs(4'sb1000);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            data_in = 4'sb1111;
            shift_amount = 2'b01;
            @(posedge clk);
            #1 #1;
 check_outputs(4'sb1110);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            data_in = 4'sb0101;
            shift_amount = 2'b01;
            @(posedge clk);
            #1 #1;
 check_outputs(4'sb1010);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            data_in = 4'sb1010;
            shift_amount = 2'b11;
            @(posedge clk);
            #1 #1;
 check_outputs(4'sb0000);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            data_in = 4'sb0111;
            shift_amount = 2'b00;
            rst = 1;
            @(posedge clk);
            #1;

            if (data_out === 4'b0000) begin
                $display("Test %0d: PASS (Reset check)", test_num+1);
                pass_count = pass_count + 1;
            end else begin
                $display("Test %0d: FAIL (Reset check)", test_num+1);
                fail_count = fail_count + 1;
            end
            test_num = test_num + 1;
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
        testcase008();
        
        
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
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h",
                         expected_data_out);
                $display("  Got:      data_out=%h",
                         data_out);
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
        $dumpvars(0,clk, data_in, rst, shift_amount, data_out);
    end

endmodule
