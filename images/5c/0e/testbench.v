`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] DM_out;
    reg clk;
    reg [15:0] com_addr;
    reg [15:0] com_data_in;
    reg com_wr_en;
    reg [15:0] proc_addr;
    reg [15:0] proc_bus;
    reg proc_wr_en;
    reg [1:0] status;
    wire [15:0] DM_addr;
    wire [15:0] DM_data_in;
    wire DM_write_en;
    wire [15:0] com_data_out;
    wire [15:0] proc_data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .DM_out(DM_out),
        .clk(clk),
        .com_addr(com_addr),
        .com_data_in(com_data_in),
        .com_wr_en(com_wr_en),
        .proc_addr(proc_addr),
        .proc_bus(proc_bus),
        .proc_wr_en(proc_wr_en),
        .status(status),
        .DM_addr(DM_addr),
        .DM_data_in(DM_data_in),
        .DM_write_en(DM_write_en),
        .com_data_out(com_data_out),
        .proc_data_out(proc_data_out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Status 00 - Communication Write to DM", test_num);


            status = 2'b00;
            com_addr = 16'hAAAA;
            com_data_in = 16'h5555;
            com_wr_en = 1;
            proc_addr = 16'h1234;
            proc_bus = 16'h9999;
            proc_wr_en = 0;
            DM_out = 16'hEEEE;

            @(posedge clk);
            #2;


            #1;



            check_outputs(16'hAAAA, 16'h5555, 1'b1, 16'h0000, 16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Status 01 - Processor Access to DM", test_num);


            status = 2'b01;
            com_addr = 16'hAAAA;
            com_data_in = 16'h5555;
            com_wr_en = 1;
            proc_addr = 16'hBBBB;
            proc_bus = 16'h6666;
            proc_wr_en = 1;
            DM_out = 16'h7777;

            @(posedge clk);
            #2;


            #1;



            check_outputs(16'hBBBB, 16'h6666, 1'b1, 16'h0000, 16'h7777);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Status 10 - DM content back to Communication", test_num);


            status = 2'b10;
            com_addr = 16'hCCCC;
            com_data_in = 16'h1111;
            com_wr_en = 0;
            proc_addr = 16'h1234;
            proc_bus = 16'h9999;
            proc_wr_en = 1;
            DM_out = 16'h8888;

            @(posedge clk);
            #2;


            #1;



            check_outputs(16'hCCCC, 16'h1111, 1'b0, 16'h8888, 16'h0000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Status 11 - Default state", test_num);

            status = 2'b11;
            com_addr = 16'hFFFF;
            com_data_in = 16'hFFFF;
            com_wr_en = 1;
            proc_addr = 16'hFFFF;
            proc_bus = 16'hFFFF;
            proc_wr_en = 1;
            DM_out = 16'hFFFF;

            @(posedge clk);
            #2;


            #1;



            check_outputs(16'h0000, 16'h0000, 1'b0, 16'h0000, 16'h0000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Status 01 - Processor Read from DM", test_num);

            status = 2'b01;
            proc_addr = 16'h1234;
            proc_bus = 16'h0000;
            proc_wr_en = 0;
            DM_out = 16'hABCD;

            @(posedge clk);
            #2;

            #1;


            check_outputs(16'h1234, 16'h0000, 1'b0, 16'h0000, 16'hABCD);
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
        input [15:0] expected_DM_addr;
        input [15:0] expected_DM_data_in;
        input expected_DM_write_en;
        input [15:0] expected_com_data_out;
        input [15:0] expected_proc_data_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_DM_addr === (expected_DM_addr ^ DM_addr ^ expected_DM_addr) &&
                expected_DM_data_in === (expected_DM_data_in ^ DM_data_in ^ expected_DM_data_in) &&
                expected_DM_write_en === (expected_DM_write_en ^ DM_write_en ^ expected_DM_write_en) &&
                expected_com_data_out === (expected_com_data_out ^ com_data_out ^ expected_com_data_out) &&
                expected_proc_data_out === (expected_proc_data_out ^ proc_data_out ^ expected_proc_data_out)) begin
                $display("PASS");
                $display("  Outputs: DM_addr=%h, DM_data_in=%h, DM_write_en=%b, com_data_out=%h, proc_data_out=%h",
                         DM_addr, DM_data_in, DM_write_en, com_data_out, proc_data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: DM_addr=%h, DM_data_in=%h, DM_write_en=%b, com_data_out=%h, proc_data_out=%h",
                         expected_DM_addr, expected_DM_data_in, expected_DM_write_en, expected_com_data_out, expected_proc_data_out);
                $display("  Got:      DM_addr=%h, DM_data_in=%h, DM_write_en=%b, com_data_out=%h, proc_data_out=%h",
                         DM_addr, DM_data_in, DM_write_en, com_data_out, proc_data_out);
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

endmodule
