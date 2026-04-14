`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg read_en;
    reg [15:0] reg_addr;
    reg [7:0] write_data;
    reg write_en;
    wire [7:0] read_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .read_en(read_en),
        .reg_addr(reg_addr),
        .write_data(write_data),
        .write_en(write_en),
        .read_data(read_data)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            read_en = 0;
            write_en = 0;
            reg_addr = 0;
            write_data = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            $display("Testcase %03d: Basic Write and Read back", test_num);

            write_en = 1;
            reg_addr = 16'h0001;
            write_data = 8'hA5;
            @(posedge clk);
            #1;
            write_en = 0;

            read_en = 1;
            reg_addr = 16'h0001;
            #2;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            $display("Testcase %03d: Read Enable Check (read_en=0)", test_num);

            write_en = 1;
            reg_addr = 16'h0002;
            write_data = 8'h5A;
            @(posedge clk);
            #1;
            write_en = 0;

            read_en = 0;
            reg_addr = 16'h0002;
            #2;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            $display("Testcase %03d: Overwrite data", test_num);

            write_en = 1;
            reg_addr = 16'h0005;
            write_data = 8'h11;
            @(posedge clk);
            #1;

            write_data = 8'h22;
            @(posedge clk);
            #1;
            write_en = 0;

            read_en = 1;
            reg_addr = 16'h0005;
            #2;
            #1;

            check_outputs(8'h22);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            $display("Testcase %03d: Multiple registers independence", test_num);

            write_en = 1;
            reg_addr = 16'h0010;
            write_data = 8'hAA;
            @(posedge clk);
            #1;

            reg_addr = 16'h0020;
            write_data = 8'hBB;
            @(posedge clk);
            #1;
            write_en = 0;

            read_en = 1;
            reg_addr = 16'h0010;
            #2;
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            $display("Testcase %03d: Max address boundary check", test_num);

            write_en = 1;
            reg_addr = 16'hFFFF;
            write_data = 8'hFF;
            @(posedge clk);
            #1;
            write_en = 0;

            read_en = 1;
            reg_addr = 16'hFFFF;
            #2;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            $display("Testcase %03d: Zero address and zero data", test_num);
            write_en = 1;
            reg_addr = 16'h0000;
            write_data = 8'h00;
            @(posedge clk);
            #1;
            write_en = 0;
            read_en = 1;
            reg_addr = 16'h0000;
            #2;
            #1;

            check_outputs(8'h00);
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
        input [7:0] expected_read_data;
        begin
            if (expected_read_data === (expected_read_data ^ read_data ^ expected_read_data)) begin
                $display("PASS");
                $display("  Outputs: read_data=%h",
                         read_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: read_data=%h",
                         expected_read_data);
                $display("  Got:      read_data=%h",
                         read_data);
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
        $dumpvars(0,clk, read_en, reg_addr, write_data, write_en, read_data);
    end

endmodule
