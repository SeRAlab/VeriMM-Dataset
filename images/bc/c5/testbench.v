`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] data_input;
    reg [4:0] read_addr1;
    reg [4:0] read_addr2;
    reg reset;
    reg [4:0] write_addr;
    reg write_enable;
    wire [31:0] data_output1;
    wire [31:0] data_output2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_input(data_input),
        .read_addr1(read_addr1),
        .read_addr2(read_addr2),
        .reset(reset),
        .write_addr(write_addr),
        .write_enable(write_enable),
        .data_output1(data_output1),
        .data_output2(data_output2)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            write_enable = 0;
            write_addr = 0;
            data_input = 0;
            read_addr1 = 0;
            read_addr2 = 0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Reset State Verification", test_num);
            reset_dut();
            read_addr1 = 5;
            read_addr2 = 31;
            #5;
            #1;

            check_outputs(32'h0, 32'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Basic Write and Read", test_num);
            reset_dut();
            @(negedge clk);
            write_addr = 5'd1;
            data_input = 32'hABCDEF01;
            write_enable = 1;
            @(posedge clk);
            #1 write_enable = 0;

            read_addr1 = 5'd1;
            read_addr2 = 5'd0;
            #5;
            #1;

            check_outputs(32'hABCDEF01, 32'h0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Register 0 Reserved Check", test_num);
            reset_dut();
            @(negedge clk);
            write_addr = 5'd0;
            data_input = 32'hFFFFFFFF;
            write_enable = 1;
            @(posedge clk);
            #1 write_enable = 0;

            read_addr1 = 5'd0;
            read_addr2 = 5'd0;
            #5;
            #1;

            check_outputs(32'h0, 32'h0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Dual Port Read Check", test_num);
            reset_dut();

            @(negedge clk);
            write_addr = 5'd10;
            data_input = 32'h11112222;
            write_enable = 1;
            @(posedge clk);

            @(negedge clk);
            write_addr = 5'd20;
            data_input = 32'h33334444;
            write_enable = 1;
            @(posedge clk);
            #1 write_enable = 0;

            read_addr1 = 5'd10;
            read_addr2 = 5'd20;
            #5;
            #1;

            check_outputs(32'h11112222, 32'h33334444);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Write Enable Low Check", test_num);
            reset_dut();
            @(negedge clk);
            write_addr = 5'd15;
            data_input = 32'h55556666;
            write_enable = 0;
            @(posedge clk);

            read_addr1 = 5'd15;
            read_addr2 = 5'd0;
            #5;
            #1;

            check_outputs(32'h0, 32'h0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Max Address and Overwrite Check", test_num);
            reset_dut();

            @(negedge clk);
            write_addr = 5'd31;
            data_input = 32'hAAAAAAAA;
            write_enable = 1;
            @(posedge clk);

            @(negedge clk);
            data_input = 32'hBBBBBBBB;
            @(posedge clk);
            #1 write_enable = 0;

            read_addr1 = 5'd31;
            read_addr2 = 5'd31;
            #5;
            #1;

            check_outputs(32'hBBBBBBBB, 32'hBBBBBBBB);
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
        input [31:0] expected_data_output1;
        input [31:0] expected_data_output2;
        begin
            if (expected_data_output1 === (expected_data_output1 ^ data_output1 ^ expected_data_output1) &&
                expected_data_output2 === (expected_data_output2 ^ data_output2 ^ expected_data_output2)) begin
                $display("PASS");
                $display("  Outputs: data_output1=%h, data_output2=%h",
                         data_output1, data_output2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_output1=%h, data_output2=%h",
                         expected_data_output1, expected_data_output2);
                $display("  Got:      data_output1=%h, data_output2=%h",
                         data_output1, data_output2);
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
        $dumpvars(0,clk, data_input, read_addr1, read_addr2, reset, write_addr, write_enable, data_output1, data_output2);
    end

endmodule
