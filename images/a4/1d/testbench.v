`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [2:0] read_addr_1;
    reg [2:0] read_addr_2;
    reg read_en_1;
    reg read_en_2;
    reg rst_n;
    reg [2:0] write_addr_1;
    reg [2:0] write_addr_2;
    reg [3:0] write_data_1;
    reg [3:0] write_data_2;
    reg write_en_1;
    reg write_en_2;
    wire [3:0] final_output;
    wire [3:0] read_data_1;
    wire [3:0] read_data_2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .read_addr_1(read_addr_1),
        .read_addr_2(read_addr_2),
        .read_en_1(read_en_1),
        .read_en_2(read_en_2),
        .rst_n(rst_n),
        .write_addr_1(write_addr_1),
        .write_addr_2(write_addr_2),
        .write_data_1(write_data_1),
        .write_data_2(write_data_2),
        .write_en_1(write_en_1),
        .write_en_2(write_en_2),
        .final_output(final_output),
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
            rst_n = 0;
            read_addr_1 = 0;
            read_addr_2 = 0;
            read_en_1 = 0;
            read_en_2 = 0;
            write_addr_1 = 0;
            write_addr_2 = 0;
            write_data_1 = 0;
            write_data_2 = 0;
            write_en_1 = 0;
            write_en_2 = 0;
            repeat(2) @(posedge clk);
            #1 rst_n = 1;
            repeat(1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Reset and Initial Read", test_num);
            reset_dut();
            read_en_1 = 1;
            read_addr_1 = 3'd5;
            read_en_2 = 1;
            read_addr_2 = 3'd2;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'h0, 4'h0, 4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Single Port 1 Write/Read", test_num);
            reset_dut();

            write_en_1 = 1;
            write_addr_1 = 3'd3;
            write_data_1 = 4'hA;
            @(posedge clk);
            write_en_1 = 0;

            read_en_1 = 1;
            read_addr_1 = 3'd3;
            read_en_2 = 1;
            read_addr_2 = 3'd0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'hA, 4'hA, 4'h0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Single Port 2 Write/Read", test_num);
            reset_dut();

            write_en_2 = 1;
            write_addr_2 = 3'd7;
            write_data_2 = 4'h7;
            @(posedge clk);
            write_en_2 = 0;

            read_en_1 = 1;
            read_addr_1 = 3'd0;
            read_en_2 = 1;
            read_addr_2 = 3'd7;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'h7, 4'h0, 4'h7);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Simultaneous Dual Port Write/Read", test_num);
            reset_dut();

            write_en_1 = 1; write_addr_1 = 3'd1; write_data_1 = 4'hB;
            write_en_2 = 1; write_addr_2 = 3'd4; write_data_2 = 4'h4;
            @(posedge clk);
            write_en_1 = 0; write_en_2 = 0;

            read_en_1 = 1; read_addr_1 = 3'd1;
            read_en_2 = 1; read_addr_2 = 3'd4;
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'hF, 4'hB, 4'h4);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: XOR Logic Verification", test_num);
            reset_dut();

            write_en_1 = 1; write_addr_1 = 3'd0; write_data_1 = 4'hF;
            write_en_2 = 1; write_addr_2 = 3'd0; write_data_2 = 4'h3;
            @(posedge clk);
            write_en_1 = 0; write_en_2 = 0;

            read_en_1 = 1; read_addr_1 = 3'd0;
            read_en_2 = 1; read_addr_2 = 3'd0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'hC, 4'hF, 4'h3);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Write Enable Validation", test_num);
            reset_dut();

            write_en_1 = 0;
            write_addr_1 = 3'd2;
            write_data_1 = 4'hE;
            @(posedge clk);

            read_en_1 = 1;
            read_addr_1 = 3'd2;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'h0, 4'h0, 4'h0);
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
        input [3:0] expected_final_output;
        input [3:0] expected_read_data_1;
        input [3:0] expected_read_data_2;
        begin
            if (expected_final_output === (expected_final_output ^ final_output ^ expected_final_output) &&
                expected_read_data_1 === (expected_read_data_1 ^ read_data_1 ^ expected_read_data_1) &&
                expected_read_data_2 === (expected_read_data_2 ^ read_data_2 ^ expected_read_data_2)) begin
                $display("PASS");
                $display("  Outputs: final_output=%h, read_data_1=%h, read_data_2=%h",
                         final_output, read_data_1, read_data_2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: final_output=%h, read_data_1=%h, read_data_2=%h",
                         expected_final_output, expected_read_data_1, expected_read_data_2);
                $display("  Got:      final_output=%h, read_data_1=%h, read_data_2=%h",
                         final_output, read_data_1, read_data_2);
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
        $dumpvars(0,clk, read_addr_1, read_addr_2, read_en_1, read_en_2, rst_n, write_addr_1, write_addr_2, write_data_1, write_data_2, write_en_1, write_en_2, final_output, read_data_1, read_data_2);
    end

endmodule
