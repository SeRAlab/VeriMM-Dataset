`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [63:0] alu_in;
    reg clk;
    reg [4:0] rd_in;
    reg [63:0] read_data_in;
    reg [1:0] wb_in;
    wire [63:0] alu_out;
    wire [4:0] rd_out;
    wire [63:0] read_data_out;
    wire [1:0] wb_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .alu_in(alu_in),
        .clk(clk),
        .rd_in(rd_in),
        .read_data_in(read_data_in),
        .wb_in(wb_in),
        .alu_out(alu_out),
        .rd_out(rd_out),
        .read_data_out(read_data_out),
        .wb_out(wb_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            alu_in = 0;
            rd_in = 0;
            read_data_in = 0;
            wb_in = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Data Transfer", test_num);

            rd_in = 5'd10;
            alu_in = 64'hDEADBEEFCAFEBABE;
            read_data_in = 64'h1234567890ABCDEF;
            wb_in = 2'b11;

            @(posedge clk);
            #2;

            #1;


            check_outputs(64'hDEADBEEFCAFEBABE, 5'd10, 64'h1234567890ABCDEF, 2'b11);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Maximum Values", test_num);

            rd_in = 5'h1F;
            alu_in = 64'hFFFFFFFFFFFFFFFF;
            read_data_in = 64'hFFFFFFFFFFFFFFFF;
            wb_in = 2'b11;

            @(posedge clk);
            #2;

            #1;


            check_outputs(64'hFFFFFFFFFFFFFFFF, 5'h1F, 64'hFFFFFFFFFFFFFFFF, 2'b11);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Alternating Patterns", test_num);

            rd_in = 5'b10101;
            alu_in = 64'hAAAAAAAAAAAAAAAA;
            read_data_in = 64'h5555555555555555;
            wb_in = 2'b01;

            @(posedge clk);
            #2;

            #1;


            check_outputs(64'hAAAAAAAAAAAAAAAA, 5'b10101, 64'h5555555555555555, 2'b01);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Data Stability/Sequential Hold", test_num);


            rd_in = 5'd5;
            alu_in = 64'h1;
            read_data_in = 64'hA;
            wb_in = 2'b10;

            @(posedge clk);
            #1;


            rd_in = 5'd31;
            alu_in = 64'hFFFF;
            read_data_in = 64'hFFFF;
            wb_in = 2'b00;


            #1;



            check_outputs(64'h1, 5'd5, 64'hA, 2'b10);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Zero Values", test_num);

            rd_in = 5'd0;
            alu_in = 64'd0;
            read_data_in = 64'd0;
            wb_in = 2'b00;

            @(posedge clk);
            #2;

            #1;


            check_outputs(64'd0, 5'd0, 64'd0, 2'b00);
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
        input [63:0] expected_alu_out;
        input [4:0] expected_rd_out;
        input [63:0] expected_read_data_out;
        input [1:0] expected_wb_out;
        begin
            if (expected_alu_out === (expected_alu_out ^ alu_out ^ expected_alu_out) &&
                expected_rd_out === (expected_rd_out ^ rd_out ^ expected_rd_out) &&
                expected_read_data_out === (expected_read_data_out ^ read_data_out ^ expected_read_data_out) &&
                expected_wb_out === (expected_wb_out ^ wb_out ^ expected_wb_out)) begin
                $display("PASS");
                $display("  Outputs: alu_out=%h, rd_out=%h, read_data_out=%h, wb_out=%h",
                         alu_out, rd_out, read_data_out, wb_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: alu_out=%h, rd_out=%h, read_data_out=%h, wb_out=%h",
                         expected_alu_out, expected_rd_out, expected_read_data_out, expected_wb_out);
                $display("  Got:      alu_out=%h, rd_out=%h, read_data_out=%h, wb_out=%h",
                         alu_out, rd_out, read_data_out, wb_out);
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
        $dumpvars(0,alu_in, clk, rd_in, read_data_in, wb_in, alu_out, rd_out, read_data_out, wb_out);
    end

endmodule
