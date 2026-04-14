`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg id_flush;
    reg id_stall;
    reg [31:0] if_exc_data;
    reg [3:0] if_exception_i;
    reg [31:0] if_inst;
    reg [31:0] if_pc;
    reg if_trap_valid;
    reg rst;
    wire [31:0] id_exc_data;
    wire [31:0] id_inst;
    wire [31:0] id_pc;
    wire id_trap_valid;
    wire [3:0] if_exception_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .id_flush(id_flush),
        .id_stall(id_stall),
        .if_exc_data(if_exc_data),
        .if_exception_i(if_exception_i),
        .if_inst(if_inst),
        .if_pc(if_pc),
        .if_trap_valid(if_trap_valid),
        .rst(rst),
        .id_exc_data(id_exc_data),
        .id_inst(id_inst),
        .id_pc(id_pc),
        .id_trap_valid(id_trap_valid),
        .if_exception_o(if_exception_o)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            id_flush = 0;
            id_stall = 0;
            if_pc = 0;
            if_exception_i = 0;
            if_trap_valid = 0;
            if_exc_data = 0;
            if_inst = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset Behavior", test_num);
            reset_dut();

            #1;


            check_outputs(32'h0, 32'h0, 32'h0, 1'b0, 4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Normal Operation", test_num);
            reset_dut();

            @(negedge clk);
            if_pc = 32'h0000_1000;
            if_inst = 32'hDEAD_BEEF;
            if_exception_i = 4'hA;
            if_trap_valid = 1'b1;
            if_exc_data = 32'hCAFE_BABE;

            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hCAFE_BABE, 32'hDEAD_BEEF, 32'h0000_1000, 1'b1, 4'hA);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Flush Signal", test_num);
            reset_dut();


            @(negedge clk);
            if_pc = 32'h0000_2000;
            if_inst = 32'h0011_2233;
            @(posedge clk);


            @(negedge clk);
            id_flush = 1;
            if_pc = 32'h0000_3000;
            if_inst = 32'h4455_6677;

            @(posedge clk);
            #1;

            #1;


            check_outputs(32'h0, 32'h0, 32'h0, 1'b0, 4'h0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Stall Signal", test_num);
            reset_dut();


            @(negedge clk);
            if_pc = 32'h0000_4000;
            if_inst = 32'hAAAA_BBBB;
            if_exception_i = 4'h1;
            @(posedge clk);


            @(negedge clk);
            id_stall = 1;
            if_pc = 32'h0000_5000;
            if_inst = 32'hCCCC_DDDD;

            @(posedge clk);
            #1;

            #1;


            check_outputs(32'h0, 32'hAAAA_BBBB, 32'h0000_4000, 1'b0, 4'h1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Flush Priority over Stall", test_num);
            reset_dut();


            @(negedge clk);
            if_pc = 32'h0000_6000;
            if_inst = 32'h1234_5678;
            @(posedge clk);


            @(negedge clk);
            id_stall = 1;
            id_flush = 1;
            if_pc = 32'h0000_7000;

            @(posedge clk);
            #1;

            #1;


            check_outputs(32'h0, 32'h0, 32'h0, 1'b0, 4'h0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Recovery from Stall", test_num);
            reset_dut();


            @(negedge clk);
            id_stall = 1;
            if_pc = 32'h0000_8000;
            if_inst = 32'h1111_1111;
            @(posedge clk);


            @(negedge clk);
            id_stall = 0;
            if_pc = 32'h0000_9000;
            if_inst = 32'h2222_2222;

            @(posedge clk);
            #1;

            #1;


            check_outputs(32'h0, 32'h2222_2222, 32'h0000_9000, 1'b0, 4'h0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Exception and Trap Handling", test_num);
            reset_dut();

            @(negedge clk);
            if_pc = 32'hFFFF_0000;
            if_inst = 32'h0000_0000;
            if_exception_i = 4'hF;
            if_trap_valid = 1'b1;
            if_exc_data = 32'h8000_0001;

            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h8000_0001, 32'h0000_0000, 32'hFFFF_0000, 1'b1, 4'hF);
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
        testcase007();
        
        
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
        input [31:0] expected_id_exc_data;
        input [31:0] expected_id_inst;
        input [31:0] expected_id_pc;
        input expected_id_trap_valid;
        input [3:0] expected_if_exception_o;
        begin
            if (expected_id_exc_data === (expected_id_exc_data ^ id_exc_data ^ expected_id_exc_data) &&
                expected_id_inst === (expected_id_inst ^ id_inst ^ expected_id_inst) &&
                expected_id_pc === (expected_id_pc ^ id_pc ^ expected_id_pc) &&
                expected_id_trap_valid === (expected_id_trap_valid ^ id_trap_valid ^ expected_id_trap_valid) &&
                expected_if_exception_o === (expected_if_exception_o ^ if_exception_o ^ expected_if_exception_o)) begin
                $display("PASS");
                $display("  Outputs: id_exc_data=%h, id_inst=%h, id_pc=%h, id_trap_valid=%b, if_exception_o=%h",
                         id_exc_data, id_inst, id_pc, id_trap_valid, if_exception_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: id_exc_data=%h, id_inst=%h, id_pc=%h, id_trap_valid=%b, if_exception_o=%h",
                         expected_id_exc_data, expected_id_inst, expected_id_pc, expected_id_trap_valid, expected_if_exception_o);
                $display("  Got:      id_exc_data=%h, id_inst=%h, id_pc=%h, id_trap_valid=%b, if_exception_o=%h",
                         id_exc_data, id_inst, id_pc, id_trap_valid, if_exception_o);
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
        $dumpvars(0,clk, id_flush, id_stall, if_exc_data, if_exception_i, if_inst, if_pc, if_trap_valid, rst, id_exc_data, id_inst, id_pc, id_trap_valid, if_exception_o);
    end

endmodule
