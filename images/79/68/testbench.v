`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [1:0] addr;
    reg clk;
    reg [7:0] data_in;
    reg we;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr(addr),
        .clk(clk),
        .data_in(data_in),
        .we(we),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            we = 1;
            addr = 2'b00; data_in = 8'h00; @(posedge clk);
            addr = 2'b01; data_in = 8'h00; @(posedge clk);
            addr = 2'b10; data_in = 8'h00; @(posedge clk);
            addr = 2'b11; data_in = 8'h00; @(posedge clk);
            we = 0;
            addr = 0;
            data_in = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Basic Write/Read Address 0", test_num);
            reset_dut();

            we = 1;
            addr = 2'b00;
            data_in = 8'hA5;
            @(posedge clk);

            we = 0;
            #2;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Write Enable Check", test_num);
            reset_dut();

            we = 0;
            addr = 2'b01;
            data_in = 8'hFF;
            @(posedge clk);

            #2;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Multiple Register Independence", test_num);
            reset_dut();

            we = 1;
            addr = 2'b00; data_in = 8'h11; @(posedge clk);
            addr = 2'b01; data_in = 8'h22; @(posedge clk);
            addr = 2'b10; data_in = 8'h33; @(posedge clk);
            addr = 2'b11; data_in = 8'h44; @(posedge clk);

            we = 0;
            addr = 2'b10;
            #2;
            #1;

            check_outputs(8'h33);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Overwrite Check", test_num);
            reset_dut();

            we = 1;
            addr = 2'b11;
            data_in = 8'hAA;
            @(posedge clk);

            data_in = 8'hBB;
            @(posedge clk);

            we = 0;
            #2;
            #1;

            check_outputs(8'hBB);
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
        $dumpvars(0,addr, clk, data_in, we, data_out);
    end

endmodule
