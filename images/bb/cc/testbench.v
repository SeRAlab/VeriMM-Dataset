`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] addr;
    reg bytew;
    reg clk;
    reg [15:0] d_in;
    reg we;
    wire [15:0] d_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr(addr),
        .bytew(bytew),
        .clk(clk),
        .d_in(d_in),
        .we(we),
        .d_out(d_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            addr = 16'h0;
            bytew = 1'b0;
            d_in = 16'h0;
            we = 1'b0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            $display("Test Case 001: Full Word Write and Read (Addr: 0x0000, Data: 0xABCD)");


            addr = 16'h0000;
            d_in = 16'hABCD;
            bytew = 1'b0;
            we = 1'b1;
            @(posedge clk);


            #1;
            we = 1'b0;
            addr = 16'h0000;
            #2;
            #1;

            check_outputs(16'hABCD);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            $display("Test Case 002: Full Word Write and Read (Addr: 0x1234, Data: 0x55AA)");

            addr = 16'h1234;
            d_in = 16'h55AA;
            bytew = 1'b0;
            we = 1'b1;
            @(posedge clk);

            #1;
            we = 1'b0;
            addr = 16'h1234;
            #2;
            #1;

            check_outputs(16'h55AA);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            $display("Test Case 003: Byte Write Lower (Addr: 0x0010, Data: 0x00FF)");


            addr = 16'h0010;
            d_in = 16'h0000;
            bytew = 1'b0;
            we = 1'b1;
            @(posedge clk);


            #1;
            addr = 16'h0010;
            d_in = 16'h12FF;
            bytew = 1'b1;
            we = 1'b1;
            @(posedge clk);

            #1;
            we = 1'b0;
            addr = 16'h0010;
            #2;
            #1;

            check_outputs(16'h00FF);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            $display("Test Case 004: Byte Write Upper (Addr: 0x0011, Data: 0xEE00)");


            addr = 16'h0010;
            d_in = 16'h0000;
            bytew = 1'b0;
            we = 1'b1;
            @(posedge clk);


            #1;
            addr = 16'h0011;
            d_in = 16'h00EE;
            bytew = 1'b1;
            we = 1'b1;
            @(posedge clk);

            #1;
            we = 1'b0;
            addr = 16'h0010;
            #2;
            #1;

            check_outputs(16'hEE00);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            $display("Test Case 005: Read Shifted Byte (Addr: 0x0021, Word: 0x1234)");


            addr = 16'h0020;
            d_in = 16'h1234;
            bytew = 1'b0;
            we = 1'b1;
            @(posedge clk);

            #1;
            we = 1'b0;
            addr = 16'h0021;
            #2;

            #1;


            check_outputs(16'h0012);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            $display("Test Case 006: Overwriting word with lower byte");


            addr = 16'h0040;
            d_in = 16'hFFFF;
            bytew = 1'b0;
            we = 1'b1;
            @(posedge clk);


            #1;
            addr = 16'h0040;
            d_in = 16'hAA00;
            bytew = 1'b1;
            we = 1'b1;
            @(posedge clk);

            #1;
            we = 1'b0;
            addr = 16'h0040;
            #2;
            #1;

            check_outputs(16'hFF00);
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
        input [15:0] expected_d_out;
        begin
            if (expected_d_out === (expected_d_out ^ d_out ^ expected_d_out)) begin
                $display("PASS");
                $display("  Outputs: d_out=%h",
                         d_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: d_out=%h",
                         expected_d_out);
                $display("  Got:      d_out=%h",
                         d_out);
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
        $dumpvars(0,addr, bytew, clk, d_in, we, d_out);
    end

endmodule
