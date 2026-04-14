`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] mem_alu_data;
    reg mem_flush;
    reg [4:0] mem_gpr_wa;
    reg mem_gpr_we;
    reg mem_mem_to_gpr_select;
    reg [31:0] mem_read_data;
    reg mem_stall;
    reg rst;
    reg wb_stall;
    wire [31:0] wb_alu_data;
    wire [4:0] wb_gpr_wa;
    wire wb_gpr_we;
    wire wb_mem_to_gpr_select;
    wire [31:0] wb_read_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .mem_alu_data(mem_alu_data),
        .mem_flush(mem_flush),
        .mem_gpr_wa(mem_gpr_wa),
        .mem_gpr_we(mem_gpr_we),
        .mem_mem_to_gpr_select(mem_mem_to_gpr_select),
        .mem_read_data(mem_read_data),
        .mem_stall(mem_stall),
        .rst(rst),
        .wb_stall(wb_stall),
        .wb_alu_data(wb_alu_data),
        .wb_gpr_wa(wb_gpr_wa),
        .wb_gpr_we(wb_gpr_we),
        .wb_mem_to_gpr_select(wb_mem_to_gpr_select),
        .wb_read_data(wb_read_data)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            mem_read_data = 0;
            mem_alu_data = 0;
            mem_gpr_wa = 0;
            mem_mem_to_gpr_select = 0;
            mem_gpr_we = 0;
            mem_flush = 0;
            mem_stall = 0;
            wb_stall = 0;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Basic Reset Check");
            test_num = test_num + 1;
            reset_dut();

            #1;


            check_outputs(32'h0, 5'h0, 1'b0, 1'b0, 32'h0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Normal Data Propagation");
            test_num = test_num + 1;
            reset_dut();


            mem_read_data = 32'hDEADBEEF;
            mem_alu_data  = 32'h12345678;
            mem_gpr_wa    = 5'd15;
            mem_mem_to_gpr_select = 1'b1;
            mem_gpr_we    = 1'b1;

            @(posedge clk);
            #2;
            #1;

            check_outputs(32'h12345678, 5'd15, 1'b1, 1'b1, 32'hDEADBEEF);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Write-back Stall");
            test_num = test_num + 1;
            reset_dut();


            mem_read_data = 32'h11111111;
            mem_alu_data  = 32'hAAAA0000;
            mem_gpr_wa    = 5'd10;
            mem_mem_to_gpr_select = 1'b0;
            mem_gpr_we    = 1'b1;
            @(posedge clk);
            #2;


            wb_stall = 1'b1;
            mem_read_data = 32'h22222222;
            mem_alu_data  = 32'hBBBB0000;
            mem_gpr_wa    = 5'd20;
            @(posedge clk);
            #2;


            #1;



            check_outputs(32'hAAAA0000, 5'd10, 1'b1, 1'b0, 32'h11111111);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Flush Handling");
            test_num = test_num + 1;
            reset_dut();


            mem_read_data = 32'hCAFEBABE;
            mem_alu_data  = 32'h5555AAAA;
            mem_gpr_wa    = 5'd5;
            mem_mem_to_gpr_select = 1'b1;
            mem_gpr_we    = 1'b1;
            mem_flush     = 1'b1;

            @(posedge clk);
            #2;




            #1;





            check_outputs(32'h5555AAAA, 5'd5, 1'b0, 1'b1, 32'hCAFEBABE);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Memory Stall Handling");
            test_num = test_num + 1;
            reset_dut();


            mem_read_data = 32'h88887777;
            mem_alu_data  = 32'h66665555;
            mem_gpr_wa    = 5'd31;
            mem_mem_to_gpr_select = 1'b0;
            mem_gpr_we    = 1'b1;
            mem_stall     = 1'b1;

            @(posedge clk);
            #2;


            #1;



            check_outputs(32'h66665555, 5'd31, 1'b0, 1'b0, 32'h88887777);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Sequential Updates");
            test_num = test_num + 1;
            reset_dut();


            mem_read_data = 32'h1; mem_alu_data = 32'hA; mem_gpr_wa = 5'd1; mem_gpr_we = 1'b1;
            @(posedge clk); #2;


            mem_read_data = 32'h2; mem_alu_data = 32'hB; mem_gpr_wa = 5'd2; mem_gpr_we = 1'b1;
            @(posedge clk); #2;


            mem_read_data = 32'h3; mem_alu_data = 32'hC; mem_gpr_wa = 5'd3; mem_gpr_we = 1'b0;
            @(posedge clk);
            #2;


            #1;



            check_outputs(32'hC, 5'd3, 1'b0, 1'b0, 32'h3);
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
        input [31:0] expected_wb_alu_data;
        input [4:0] expected_wb_gpr_wa;
        input expected_wb_gpr_we;
        input expected_wb_mem_to_gpr_select;
        input [31:0] expected_wb_read_data;
        begin
            if (expected_wb_alu_data === (expected_wb_alu_data ^ wb_alu_data ^ expected_wb_alu_data) &&
                expected_wb_gpr_wa === (expected_wb_gpr_wa ^ wb_gpr_wa ^ expected_wb_gpr_wa) &&
                expected_wb_gpr_we === (expected_wb_gpr_we ^ wb_gpr_we ^ expected_wb_gpr_we) &&
                expected_wb_mem_to_gpr_select === (expected_wb_mem_to_gpr_select ^ wb_mem_to_gpr_select ^ expected_wb_mem_to_gpr_select) &&
                expected_wb_read_data === (expected_wb_read_data ^ wb_read_data ^ expected_wb_read_data)) begin
                $display("PASS");
                $display("  Outputs: wb_alu_data=%h, wb_gpr_wa=%h, wb_gpr_we=%b, wb_mem_to_gpr_select=%b, wb_read_data=%h",
                         wb_alu_data, wb_gpr_wa, wb_gpr_we, wb_mem_to_gpr_select, wb_read_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: wb_alu_data=%h, wb_gpr_wa=%h, wb_gpr_we=%b, wb_mem_to_gpr_select=%b, wb_read_data=%h",
                         expected_wb_alu_data, expected_wb_gpr_wa, expected_wb_gpr_we, expected_wb_mem_to_gpr_select, expected_wb_read_data);
                $display("  Got:      wb_alu_data=%h, wb_gpr_wa=%h, wb_gpr_we=%b, wb_mem_to_gpr_select=%b, wb_read_data=%h",
                         wb_alu_data, wb_gpr_wa, wb_gpr_we, wb_mem_to_gpr_select, wb_read_data);
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
        $dumpvars(0,clk, mem_alu_data, mem_flush, mem_gpr_wa, mem_gpr_we, mem_mem_to_gpr_select, mem_read_data, mem_stall, rst, wb_stall, wb_alu_data, wb_gpr_wa, wb_gpr_we, wb_mem_to_gpr_select, wb_read_data);
    end

endmodule
