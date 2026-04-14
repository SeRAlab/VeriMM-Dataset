`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [23:0] data_in;
    reg [9:0] read_addr;
    reg [9:0] write_addr;
    reg write_en;
    wire [23:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_in(data_in),
        .read_addr(read_addr),
        .write_addr(write_addr),
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
            write_en = 0;
            data_in = 0;
            write_addr = 0;
            read_addr = 0;
            @(negedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;

            @(negedge clk);
            write_en = 1;
            write_addr = 10'h010;
            data_in = 24'hABCDEF;
            @(negedge clk);
            write_en = 0;

            read_addr = 10'h010;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Basic Write/Read", test_num);
            #1;

            check_outputs(24'hABCDEF);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;

            @(negedge clk);
            write_en = 1;
            write_addr = 10'h3FF;
            data_in = 24'hFFFFFF;
            @(negedge clk);
            write_en = 0;
            read_addr = 10'h3FF;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Boundary Address (0x3FF)", test_num);
            #1;

            check_outputs(24'hFFFFFF);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;

            @(negedge clk);
            write_en = 1;
            write_addr = 10'h005;
            data_in = 24'h112233;
            @(negedge clk);

            write_en = 0;
            write_addr = 10'h005;
            data_in = 24'h998877;
            @(negedge clk);

            read_addr = 10'h005;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Write Enable Low Verification", test_num);

            #1;


            check_outputs(24'h112233);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;

            @(negedge clk);
            write_en = 1;
            write_addr = 10'h0A0;
            data_in = 24'h000001;
            @(negedge clk);

            write_en = 1;
            write_addr = 10'h0A0;
            data_in = 24'h888888;
            @(negedge clk);
            write_en = 0;
            read_addr = 10'h0A0;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Data Overwrite", test_num);
            #1;

            check_outputs(24'h888888);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;

            @(negedge clk);
            write_en = 1;
            write_addr = 10'h001;
            data_in = 24'h555555;
            @(negedge clk);

            write_en = 1;
            write_addr = 10'h002;
            data_in = 24'hAAAAAA;
            read_addr = 10'h001;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Simultaneous Read/Write Different Addr", test_num);
            #1;

            check_outputs(24'h555555);
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
        input [23:0] expected_data_out;
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
        $dumpvars(0,clk, data_in, read_addr, write_addr, write_en, data_out);
    end

endmodule
