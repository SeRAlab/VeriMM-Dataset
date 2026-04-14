`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg [15:0] ex_alu_result;
    reg [15:0] mem_read_data;
    reg reset;
    reg [2:0] write_back_dest;
    reg write_back_en;
    reg write_back_result_mux;
    wire [36:0] RegMemToWBOut;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .ex_alu_result(ex_alu_result),
        .mem_read_data(mem_read_data),
        .reset(reset),
        .write_back_dest(write_back_dest),
        .write_back_en(write_back_en),
        .write_back_result_mux(write_back_result_mux),
        .RegMemToWBOut(RegMemToWBOut)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            @(posedge clock);
            reset = 1;
            ex_alu_result = 0;
            mem_read_data = 0;
            write_back_en = 0;
            write_back_dest = 0;
            write_back_result_mux = 0;
            @(posedge clock);
            #1;
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset Check", test_num);
            reset_dut();

            #1;


            check_outputs(37'h0000000000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Normal Write (Set 1)", test_num);
            reset_dut();
            @(posedge clock);
            write_back_en = 1;
            write_back_result_mux = 1;
            write_back_dest = 3'd3;
            mem_read_data = 16'h5678;
            ex_alu_result = 16'h1234;
            @(posedge clock);
            #1;
            #1;

            check_outputs(37'h1B56781234);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Write Enable Low", test_num);
            reset_dut();
            @(posedge clock);
            write_back_en = 0;
            write_back_result_mux = 0;
            write_back_dest = 3'd7;
            mem_read_data = 16'h0000;
            ex_alu_result = 16'hFFFF;
            @(posedge clock);
            #1;
            #1;

            check_outputs(37'h070000FFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Alternating Bits Pattern", test_num);
            reset_dut();
            @(posedge clock);
            write_back_en = 1;
            write_back_result_mux = 0;
            write_back_dest = 3'd2;
            mem_read_data = 16'hAAAA;
            ex_alu_result = 16'h5555;
            @(posedge clock);
            #1;
            #1;

            check_outputs(37'h12AAAA5555);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Boundary Values All Ones", test_num);
            reset_dut();
            @(posedge clock);
            write_back_en = 1;
            write_back_result_mux = 1;
            write_back_dest = 3'd7;
            mem_read_data = 16'hFFFF;
            ex_alu_result = 16'hFFFF;
            @(posedge clock);
            #1;
            #1;

            check_outputs(37'h1FFFFFFFFF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Multi-cycle Update Sequence", test_num);
            reset_dut();


            @(posedge clock);
            write_back_en = 1; write_back_result_mux = 0; write_back_dest = 3'd1;
            mem_read_data = 16'h1111; ex_alu_result = 16'h2222;


            @(posedge clock);
            write_back_en = 0; write_back_result_mux = 1; write_back_dest = 3'd4;
            mem_read_data = 16'h3333; ex_alu_result = 16'h4444;

            @(posedge clock);
            #1;


            #1;



            check_outputs(37'h0C33334444);
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
        input [36:0] expected_RegMemToWBOut;
        begin
            if (expected_RegMemToWBOut === (expected_RegMemToWBOut ^ RegMemToWBOut ^ expected_RegMemToWBOut)) begin
                $display("PASS");
                $display("  Outputs: RegMemToWBOut=%h",
                         RegMemToWBOut);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: RegMemToWBOut=%h",
                         expected_RegMemToWBOut);
                $display("  Got:      RegMemToWBOut=%h",
                         RegMemToWBOut);
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
        $dumpvars(0,clock, ex_alu_result, mem_read_data, reset, write_back_dest, write_back_en, write_back_result_mux, RegMemToWBOut);
    end

endmodule
