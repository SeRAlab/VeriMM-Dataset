`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [5:0] addr;
    reg clk;
    reg en;
    reg write;
    reg [22:0] write_data;
    wire [22:0] read_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr(addr),
        .clk(clk),
        .en(en),
        .write(write),
        .write_data(write_data),
        .read_data(read_data)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            en = 0;
            write = 0;
            addr = 0;
            write_data = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Write and Read", test_num);


            en = 1; write = 1; addr = 6'h05; write_data = 23'h123456;
            @(posedge clk);
            #1;


            en = 1; write = 0; addr = 6'h05;
            @(posedge clk);
            #1;

            #1;


            check_outputs(23'h123456);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Max Address Boundary (0x3F)", test_num);


            en = 1; write = 1; addr = 6'd63; write_data = 23'h7FFFFF;
            @(posedge clk);
            #1;


            en = 1; write = 0; addr = 6'd63;
            @(posedge clk);
            #1;

            #1;


            check_outputs(23'h7FFFFF);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Overwriting data", test_num);


            en = 1; write = 1; addr = 6'h10; write_data = 23'h000AAA;
            @(posedge clk);
            #1;


            en = 1; write = 1; addr = 6'h10; write_data = 23'h000BBB;
            @(posedge clk);
            #1;


            en = 1; write = 0; addr = 6'h10;
            @(posedge clk);
            #1;

            #1;


            check_outputs(23'h000BBB);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Enable signal check (Write ignore)", test_num);


            en = 1; write = 1; addr = 6'h20; write_data = 23'h555555;
            @(posedge clk);
            #1;


            en = 0; write = 1; addr = 6'h20; write_data = 23'hCCCCCC;
            @(posedge clk);
            #1;


            en = 1; write = 0; addr = 6'h20;
            @(posedge clk);
            #1;

            #1;


            check_outputs(23'h555555);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Write signal check (Read mode)", test_num);


            en = 1; write = 1; addr = 6'h15; write_data = 23'h111111;
            @(posedge clk);
            #1;


            en = 1; write = 0; addr = 6'h15; write_data = 23'h222222;
            @(posedge clk);
            #1;


            en = 1; write = 0; addr = 6'h15;
            @(posedge clk);
            #1;

            #1;


            check_outputs(23'h111111);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Multiple address access", test_num);


            en = 1; write = 1; addr = 6'h01; write_data = 23'hAAAAAA;
            @(posedge clk);
            #1;


            en = 1; write = 1; addr = 6'h02; write_data = 23'hBBBBBB;
            @(posedge clk);
            #1;


            en = 1; write = 0; addr = 6'h01;
            @(posedge clk);
            #1;

            #1;


            check_outputs(23'hAAAAAA);
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
        input [22:0] expected_read_data;
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
        $dumpvars(0,addr, clk, en, write, write_data, read_data);
    end

endmodule
