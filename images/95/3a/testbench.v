`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] addr;
    reg clk;
    reg [7:0] data_in;
    reg rst;
    reg we;
    wire [7:0] data_out;
    wire [3:0] ecc;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr(addr),
        .clk(clk),
        .data_in(data_in),
        .rst(rst),
        .we(we),
        .data_out(data_out),
        .ecc(ecc)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            we = 0;
            addr = 0;
            data_in = 0;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Basic Write/Read 8'hA5 at Address 0x01", test_num);
            reset_dut();

            @(posedge clk);
            addr = 8'h01;
            data_in = 8'hA5;
            we = 1;
            @(posedge clk);
            we = 0;

            @(posedge clk);
            addr = 8'h01;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hA5, 4'h3);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Basic Write/Read 8'h5A at Address 0x02", test_num);
            reset_dut();

            @(posedge clk);
            addr = 8'h02;
            data_in = 8'h5A;
            we = 1;
            @(posedge clk);
            we = 0;

            @(posedge clk);
            addr = 8'h02;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h5A, 4'h0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Write/Read All Ones (8'hFF) at Address 0xFF", test_num);
            reset_dut();

            @(posedge clk);
            addr = 8'hFF;
            data_in = 8'hFF;
            we = 1;
            @(posedge clk);
            we = 0;

            @(posedge clk);
            addr = 8'hFF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hFF, 4'h3);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Write/Read All Zeros (8'h00) at Address 0x00", test_num);
            reset_dut();

            @(posedge clk);
            addr = 8'h00;
            data_in = 8'h00;
            we = 1;
            @(posedge clk);
            we = 0;

            @(posedge clk);
            addr = 8'h00;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h00, 4'h0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Write/Read Single Bit Set (8'h01) at Address 0x10", test_num);
            reset_dut();

            @(posedge clk);
            addr = 8'h10;
            data_in = 8'h01;
            we = 1;
            @(posedge clk);
            we = 0;

            @(posedge clk);
            addr = 8'h10;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h01, 4'hC);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Multiple Write Sequence Verification", test_num);
            reset_dut();

            @(posedge clk);
            addr = 8'h10; data_in = 8'hAA; we = 1;
            @(posedge clk);

            addr = 8'h20; data_in = 8'h55; we = 1;
            @(posedge clk);
            we = 0;


            addr = 8'h10;
            @(posedge clk);
            #1;
            if (data_out !== 8'hAA) begin
                $display("Crosstalk failure at 0x10");
            end


            @(posedge clk);
            addr = 8'h20;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h55, 4'h0);
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
        input [7:0] expected_data_out;
        input [3:0] expected_ecc;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_ecc === (expected_ecc ^ ecc ^ expected_ecc)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, ecc=%h",
                         data_out, ecc);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, ecc=%h",
                         expected_data_out, expected_ecc);
                $display("  Got:      data_out=%h, ecc=%h",
                         data_out, ecc);
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
        $dumpvars(0,addr, clk, data_in, rst, we, data_out, ecc);
    end

endmodule
