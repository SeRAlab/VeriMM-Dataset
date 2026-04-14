`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg [3:0] ex_alu_cmd;
    reg [15:0] ex_alu_src1;
    reg [15:0] ex_alu_src2;
    reg [15:0] mem_write_data;
    reg mem_write_en;
    reg reset;
    reg stall;
    reg [2:0] write_back_dest;
    reg write_back_en;
    reg write_back_result_mux;
    wire [57:0] RegIDToExOut;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .ex_alu_cmd(ex_alu_cmd),
        .ex_alu_src1(ex_alu_src1),
        .ex_alu_src2(ex_alu_src2),
        .mem_write_data(mem_write_data),
        .mem_write_en(mem_write_en),
        .reset(reset),
        .stall(stall),
        .write_back_dest(write_back_dest),
        .write_back_en(write_back_en),
        .write_back_result_mux(write_back_result_mux),
        .RegIDToExOut(RegIDToExOut)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            reset = 1;
            stall = 0;
            ex_alu_cmd = 0;
            ex_alu_src1 = 0;
            ex_alu_src2 = 0;
            mem_write_data = 0;
            mem_write_en = 0;
            write_back_dest = 0;
            write_back_en = 0;
            write_back_result_mux = 0;
            @(posedge clock);
            #1 reset = 0;
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning testcase001: Reset check...");
            reset_dut();

            #1;


            check_outputs(58'd0);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning testcase002: Basic Load...");
            reset_dut();
            ex_alu_cmd = 4'hA;
            ex_alu_src1 = 16'h1111;
            ex_alu_src2 = 16'h2222;
            mem_write_en = 1'b1;
            mem_write_data = 16'h3333;
            write_back_en = 1'b1;
            write_back_dest = 3'h5;
            write_back_result_mux = 1'b1;
            stall = 0;

            @(posedge clock);

            #1;


            check_outputs({4'hA, 16'h1111, 16'h2222, 1'b1, 16'h3333, 1'b1, 3'h5, 1'b1});
        end
        endtask

    task testcase003;

        reg [57:0] prev_state;
        begin
            $display("\nRunning testcase003: Stall logic check...");
            reset_dut();


            ex_alu_cmd = 4'h1; ex_alu_src1 = 16'hAAAA; ex_alu_src2 = 16'hBBBB;
            mem_write_en = 0; mem_write_data = 16'h0; write_back_en = 0;
            write_back_dest = 3'h0; write_back_result_mux = 0;
            @(posedge clock);
            #1;
            prev_state = RegIDToExOut;


            stall = 1;
            ex_alu_cmd = 4'hF; ex_alu_src1 = 16'hFFFF;
            @(posedge clock);


            #1;



            check_outputs(prev_state);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning testcase004: Continuous updates...");
            reset_dut();


            ex_alu_cmd = 4'h5; ex_alu_src1 = 16'h1234; ex_alu_src2 = 16'h4321;
            mem_write_en = 1; mem_write_data = 16'hABCD;
            write_back_en = 1; write_back_dest = 3'h2; write_back_result_mux = 0;
            @(posedge clock);


            ex_alu_cmd = 4'h2; ex_alu_src1 = 16'h5678; ex_alu_src2 = 16'h8765;
            mem_write_en = 0; mem_write_data = 16'hDEAD;
            write_back_en = 0; write_back_dest = 3'h7; write_back_result_mux = 1;
            @(posedge clock);

            #1;


            check_outputs({4'h2, 16'h5678, 16'h8765, 1'b0, 16'hDEAD, 1'b0, 3'h7, 1'b1});
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning testcase005: Recover from stall then reset...");
            reset_dut();


            stall = 1;
            ex_alu_cmd = 4'hC;
            @(posedge clock);


            stall = 0;
            ex_alu_cmd = 4'hC; ex_alu_src1 = 16'hC0DE; ex_alu_src2 = 16'hC0DE;
            mem_write_en = 1; mem_write_data = 16'hBEEF;
            write_back_en = 1; write_back_dest = 3'h4; write_back_result_mux = 0;
            @(posedge clock);


            reset = 1;
            @(posedge clock);

            #1;


            check_outputs(58'd0);
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
        input [57:0] expected_RegIDToExOut;
        begin
            if (expected_RegIDToExOut === (expected_RegIDToExOut ^ RegIDToExOut ^ expected_RegIDToExOut)) begin
                $display("PASS");
                $display("  Outputs: RegIDToExOut=%h",
                         RegIDToExOut);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: RegIDToExOut=%h",
                         expected_RegIDToExOut);
                $display("  Got:      RegIDToExOut=%h",
                         RegIDToExOut);
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
        $dumpvars(0,clock, ex_alu_cmd, ex_alu_src1, ex_alu_src2, mem_write_data, mem_write_en, reset, stall, write_back_dest, write_back_en, write_back_result_mux, RegIDToExOut);
    end

endmodule
