`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] read_address_1;
    reg [3:0] read_address_2;
    reg rst;
    reg [3:0] write_address;
    reg [15:0] write_data;
    reg write_enable;
    wire [15:0] read_data_1;
    wire [15:0] read_data_2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .read_address_1(read_address_1),
        .read_address_2(read_address_2),
        .rst(rst),
        .write_address(write_address),
        .write_data(write_data),
        .write_enable(write_enable),
        .read_data_1(read_data_1),
        .read_data_2(read_data_2)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            write_enable = 0;
            write_address = 0;
            write_data = 0;
            read_address_1 = 0;
            read_address_2 = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Reset Verification", test_num);
            reset_dut();


            read_address_1 = 4'h0;
            read_address_2 = 4'hF;


            @(posedge clk);
            #2;

            #1;


            check_outputs(16'h0000, 16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Single Write and Dual Read", test_num);
            reset_dut();


            @(posedge clk);
            write_enable = 1;
            write_address = 4'h5;
            write_data = 16'hABCD;


            @(posedge clk);
            write_enable = 0;
            read_address_1 = 4'h5;
            read_address_2 = 4'h0;


            @(posedge clk);
            #2;

            #1;


            check_outputs(16'hABCD, 16'h0000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Multiple Writes and Simultaneous Reads", test_num);
            reset_dut();


            @(posedge clk);
            write_enable = 1;
            write_address = 4'hA;
            write_data = 16'h1234;


            @(posedge clk);
            write_address = 4'hB;
            write_data = 16'h5678;


            @(posedge clk);
            write_enable = 0;
            read_address_1 = 4'hA;
            read_address_2 = 4'hB;


            @(posedge clk);
            #2;

            #1;


            check_outputs(16'h1234, 16'h5678);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Write Enable Functional Check", test_num);
            reset_dut();


            @(posedge clk);
            write_enable = 0;
            write_address = 4'h3;
            write_data = 16'hDEAD;


            @(posedge clk);
            read_address_1 = 4'h3;

            @(posedge clk);
            #2;

            #1;


            check_outputs(16'h0000, 16'h0000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Overwrite check", test_num);
            reset_dut();


            @(posedge clk);
            write_enable = 1;
            write_address = 4'h7;
            write_data = 16'hAAAA;


            @(posedge clk);
            write_data = 16'h5555;


            @(posedge clk);
            write_enable = 0;
            read_address_1 = 4'h7;

            @(posedge clk);
            #2;

            #1;


            check_outputs(16'h5555, 16'h0000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Boundary Address Check", test_num);
            reset_dut();


            @(posedge clk);
            write_enable = 1;
            write_address = 4'h0;
            write_data = 16'hF0F0;


            @(posedge clk);
            write_address = 4'hF;
            write_data = 16'h0F0F;


            @(posedge clk);
            write_enable = 0;
            read_address_1 = 4'h0;
            read_address_2 = 4'hF;

            @(posedge clk);
            #2;

            #1;


            check_outputs(16'hF0F0, 16'h0F0F);
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
        input [15:0] expected_read_data_1;
        input [15:0] expected_read_data_2;
        begin
            if (expected_read_data_1 === (expected_read_data_1 ^ read_data_1 ^ expected_read_data_1) &&
                expected_read_data_2 === (expected_read_data_2 ^ read_data_2 ^ expected_read_data_2)) begin
                $display("PASS");
                $display("  Outputs: read_data_1=%h, read_data_2=%h",
                         read_data_1, read_data_2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: read_data_1=%h, read_data_2=%h",
                         expected_read_data_1, expected_read_data_2);
                $display("  Got:      read_data_1=%h, read_data_2=%h",
                         read_data_1, read_data_2);
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
        $dumpvars(0,clk, read_address_1, read_address_2, rst, write_address, write_data, write_enable, read_data_1, read_data_2);
    end

endmodule
