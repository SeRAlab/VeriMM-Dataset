`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] addr;
    reg clk;
    reg [15:0] data_in;
    reg write_en;
    wire [15:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr(addr),
        .clk(clk),
        .data_in(data_in),
        .write_en(write_en),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            addr = 0;
            write_en = 0;
            data_in = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase %03d: Basic Write and Read back", test_num);

            addr = 8'h01;
            data_in = 16'hABCD;
            write_en = 1;
            @(posedge clk);
            #1;
            write_en = 0;


            addr = 8'h01;
            #2;
            #1;

            check_outputs(16'hABCD);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase %03d: Write to high address", test_num);

            addr = 8'hFF;
            data_in = 16'h55AA;
            write_en = 1;
            @(posedge clk);
            #1;
            write_en = 0;

            addr = 8'hFF;
            #2;
            #1;

            check_outputs(16'h55AA);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase %03d: Write Enable signal low", test_num);


            addr = 8'h10;
            data_in = 16'h1111;
            write_en = 1;
            @(posedge clk);
            #1;


            data_in = 16'hEEEE;
            write_en = 0;
            @(posedge clk);
            #1;

            addr = 8'h10;
            #2;
            #1;

            check_outputs(16'h1111);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase %03d: Overwriting existing data", test_num);

            addr = 8'h05;
            data_in = 16'hAAAA;
            write_en = 1;
            @(posedge clk);
            #1;

            data_in = 16'hBBBB;
            @(posedge clk);
            #1;
            write_en = 0;

            addr = 8'h05;
            #2;
            #1;

            check_outputs(16'hBBBB);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase %03d: Persistence across multiple registers", test_num);


            addr = 8'h00; data_in = 16'h0001; write_en = 1;
            @(posedge clk); #1;


            addr = 8'h01; data_in = 16'h0002; write_en = 1;
            @(posedge clk); #1;


            addr = 8'h02; data_in = 16'h0003; write_en = 1;
            @(posedge clk); #1;

            write_en = 0;


            addr = 8'h01;
            #2;
            #1;

            check_outputs(16'h0002);
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
        input [15:0] expected_data_out;
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
        $dumpvars(0,addr, clk, data_in, write_en, data_out);
    end

endmodule
