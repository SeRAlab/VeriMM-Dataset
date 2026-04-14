`timescale 1ns/1ps

module pipelined_processor_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] instruction;
    reg reset;
    wire [2:0] reg_read1;
    wire [2:0] reg_read2;
    wire [7:0] reg_read_data1;
    wire [7:0] reg_read_data2;
    wire reg_write;
    wire [7:0] reg_write_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pipelined_processor dut (
        .clk(clk),
        .instruction(instruction),
        .reset(reset),
        .reg_read1(reg_read1),
        .reg_read2(reg_read2),
        .reg_read_data1(reg_read_data1),
        .reg_read_data2(reg_read_data2),
        .reg_write(reg_write),
        .reg_write_data(reg_write_data)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            instruction = 0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Running Testcase 001: ADD R3, R1, R2");
            test_num = 1;
            reset_dut();

            instruction = 16'h0650;
            @(posedge clk);
            instruction = 16'h0000;


            repeat(4) @(posedge clk);
            #1;


            #1;



            check_outputs(3'd0, 3'd0, 8'd0, 8'd0, 1'b1, 8'd3);
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase 002: SUB R4, R5, R2");
            test_num = 2;
            reset_dut();

            instruction = 16'h1950;
            @(posedge clk);
            instruction = 16'h0000;

            repeat(4) @(posedge clk);
            #1;


            #1;



            check_outputs(3'd0, 3'd0, 8'd0, 8'd0, 1'b1, 8'd3);
        end
        endtask

    task testcase003;

        begin
            $display("Running Testcase 003: AND R2, R6, R3");
            test_num = 3;
            reset_dut();

            instruction = 16'h2598;
            @(posedge clk);
            instruction = 16'h0000;

            repeat(4) @(posedge clk);
            #1;


            #1;



            check_outputs(3'd0, 3'd0, 8'd0, 8'd0, 1'b1, 8'd2);
        end
        endtask

    task testcase004;

        begin
            $display("Running Testcase 004: OR R7, R1, R4");
            test_num = 4;
            reset_dut();

            instruction = 16'h3E60;
            @(posedge clk);
            instruction = 16'h0000;

            repeat(4) @(posedge clk);
            #1;


            #1;



            check_outputs(3'd0, 3'd0, 8'd0, 8'd0, 1'b1, 8'd5);
        end
        endtask

    task testcase005;

        begin
            $display("Running Testcase 005: NOT R0, R2");
            test_num = 5;
            reset_dut();

            instruction = 16'h4080;
            @(posedge clk);
            instruction = 16'h0000;

            repeat(4) @(posedge clk);
            #1;


            #1;



            check_outputs(3'd0, 3'd0, 8'd0, 8'd0, 1'b1, 8'hFD);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("pipelined_processor Testbench");
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
        input [2:0] expected_reg_read1;
        input [2:0] expected_reg_read2;
        input [7:0] expected_reg_read_data1;
        input [7:0] expected_reg_read_data2;
        input expected_reg_write;
        input [7:0] expected_reg_write_data;
        begin
            if (expected_reg_read1 === (expected_reg_read1 ^ reg_read1 ^ expected_reg_read1) &&
                expected_reg_read2 === (expected_reg_read2 ^ reg_read2 ^ expected_reg_read2) &&
                expected_reg_read_data1 === (expected_reg_read_data1 ^ reg_read_data1 ^ expected_reg_read_data1) &&
                expected_reg_read_data2 === (expected_reg_read_data2 ^ reg_read_data2 ^ expected_reg_read_data2) &&
                expected_reg_write === (expected_reg_write ^ reg_write ^ expected_reg_write) &&
                expected_reg_write_data === (expected_reg_write_data ^ reg_write_data ^ expected_reg_write_data)) begin
                $display("PASS");
                $display("  Outputs: reg_read1=%h, reg_read2=%h, reg_read_data1=%h, reg_read_data2=%h, reg_write=%b, reg_write_data=%h",
                         reg_read1, reg_read2, reg_read_data1, reg_read_data2, reg_write, reg_write_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: reg_read1=%h, reg_read2=%h, reg_read_data1=%h, reg_read_data2=%h, reg_write=%b, reg_write_data=%h",
                         expected_reg_read1, expected_reg_read2, expected_reg_read_data1, expected_reg_read_data2, expected_reg_write, expected_reg_write_data);
                $display("  Got:      reg_read1=%h, reg_read2=%h, reg_read_data1=%h, reg_read_data2=%h, reg_write=%b, reg_write_data=%h",
                         reg_read1, reg_read2, reg_read_data1, reg_read_data2, reg_write, reg_write_data);
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
        $dumpvars(0,clk, instruction, reset, reg_read1, reg_read2, reg_read_data1, reg_read_data2, reg_write, reg_write_data);
    end

endmodule
