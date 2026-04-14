`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] addr;
    reg clk;
    reg [7:0] data_in;
    reg read_en;
    reg write_en;
    wire [7:0] data_out;
    wire error;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr(addr),
        .clk(clk),
        .data_in(data_in),
        .read_en(read_en),
        .write_en(write_en),
        .data_out(data_out),
        .error(error)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            addr = 8'h0;
            data_in = 8'h0;
            read_en = 0;
            write_en = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            $display("Test %0d: Write to unprotected address 0x05", test_num);
            addr = 8'h05;
            data_in = 8'hAA;
            write_en = 1;
            @(posedge clk);
            #1;
            write_en = 0;
            #1;

            check_outputs(8'h00, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            $display("Test %0d: Read from unprotected address 0x05", test_num);
            addr = 8'h05;
            read_en = 1;
            @(posedge clk);
            #1;
            read_en = 0;
            #1;

            check_outputs(8'hAA, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            $display("Test %0d: Attempt write to protected address 0x15", test_num);
            addr = 8'h15;
            data_in = 8'h55;
            write_en = 1;
            @(posedge clk);
            #1;
            write_en = 0;
            #1;

            check_outputs(data_out, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            $display("Test %0d: Attempt read from protected address 0x15", test_num);
            addr = 8'h15;
            read_en = 1;
            @(posedge clk);
            #1;
            read_en = 0;
            #1;

            check_outputs(data_out, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            $display("Test %0d: Boundary Check - Address 0x10 (prot_start)", test_num);
            addr = 8'h10;
            write_en = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(data_out, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            $display("Test %0d: Boundary Check - Address 0x20 (prot_end)", test_num);
            addr = 8'h20;
            read_en = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(data_out, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            $display("Test %0d: Boundary Check - Address 0x0F (prot_start - 1)", test_num);
            addr = 8'h0F;
            data_in = 8'hBB;
            write_en = 1;
            @(posedge clk);
            #1;
            write_en = 0;
            #1;

            check_outputs(8'h00, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            reset_dut();
            $display("Test %0d: Boundary Check - Address 0x21 (prot_end + 1)", test_num);
            addr = 8'h21;
            data_in = 8'hCC;
            write_en = 1;
            @(posedge clk);
            #1;
            write_en = 0;
            #1;

            check_outputs(8'h00, 1'b0);
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
        input [7:0] expected_data_out;
        input expected_error;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_error === (expected_error ^ error ^ expected_error)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, error=%b",
                         data_out, error);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, error=%b",
                         expected_data_out, expected_error);
                $display("  Got:      data_out=%h, error=%b",
                         data_out, error);
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
        $dumpvars(0,addr, clk, data_in, read_en, write_en, data_out, error);
    end

endmodule
