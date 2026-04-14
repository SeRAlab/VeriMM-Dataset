`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg [15:0] ex_alu_result;
    reg [15:0] mem_write_data;
    reg mem_write_en;
    reg reset;
    reg [2:0] write_back_dest;
    reg write_back_en;
    reg write_back_result_mux;
    wire [37:0] RegExToMemOut;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .ex_alu_result(ex_alu_result),
        .mem_write_data(mem_write_data),
        .mem_write_en(mem_write_en),
        .reset(reset),
        .write_back_dest(write_back_dest),
        .write_back_en(write_back_en),
        .write_back_result_mux(write_back_result_mux),
        .RegExToMemOut(RegExToMemOut)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            reset = 1;
            ex_alu_result = 0;
            mem_write_data = 0;
            mem_write_en = 0;
            write_back_dest = 0;
            write_back_en = 0;
            write_back_result_mux = 0;
            @(posedge clock);
            #2;
            reset = 0;
            @(posedge clock);
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Reset Check", test_num);
            reset_dut();


            #1;



            check_outputs(38'h0);
        end
        endtask

    task testcase002;

        reg [37:0] expected;
        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Standard Data Load", test_num);
            reset_dut();


            ex_alu_result = 16'hABCD;
            mem_write_en = 1'b1;
            mem_write_data = 16'h1234;
            write_back_en = 1'b1;
            write_back_dest = 3'b101;
            write_back_result_mux = 1'b1;


            expected = {16'hABCD, 1'b1, 16'h1234, 1'b1, 3'b101, 1'b1};

            @(posedge clock);
            #2;
            #1;

            check_outputs(expected);
        end
        endtask

    task testcase003;

        reg [37:0] expected;
        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Zeros Data with Flags", test_num);
            reset_dut();

            ex_alu_result = 16'h0000;
            mem_write_en = 1'b0;
            mem_write_data = 16'h0000;
            write_back_en = 1'b1;
            write_back_dest = 3'b000;
            write_back_result_mux = 1'b0;

            expected = {16'h0000, 1'b0, 16'h0000, 1'b1, 3'b000, 1'b0};

            @(posedge clock);
            #2;
            #1;

            check_outputs(expected);
        end
        endtask

    task testcase004;

        reg [37:0] expected;
        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Bits High", test_num);
            reset_dut();

            ex_alu_result = 16'hFFFF;
            mem_write_en = 1'b1;
            mem_write_data = 16'hFFFF;
            write_back_en = 1'b1;
            write_back_dest = 3'b111;
            write_back_result_mux = 1'b1;

            expected = 38'h3FFFFFFFFF;

            @(posedge clock);
            #2;
            #1;

            check_outputs(expected);
        end
        endtask

    task testcase005;

        reg [37:0] expected;
        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating Bits", test_num);
            reset_dut();

            ex_alu_result = 16'h5555;
            mem_write_en = 1'b0;
            mem_write_data = 16'hAAAA;
            write_back_en = 1'b0;
            write_back_dest = 3'b101;
            write_back_result_mux = 1'b0;

            expected = {16'h5555, 1'b0, 16'hAAAA, 1'b0, 3'b101, 1'b0};

            @(posedge clock);
            #2;
            #1;

            check_outputs(expected);
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
        input [37:0] expected_RegExToMemOut;
        begin
            if (expected_RegExToMemOut === (expected_RegExToMemOut ^ RegExToMemOut ^ expected_RegExToMemOut)) begin
                $display("PASS");
                $display("  Outputs: RegExToMemOut=%h",
                         RegExToMemOut);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: RegExToMemOut=%h",
                         expected_RegExToMemOut);
                $display("  Got:      RegExToMemOut=%h",
                         RegExToMemOut);
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
        $dumpvars(0,clock, ex_alu_result, mem_write_data, mem_write_en, reset, write_back_dest, write_back_en, write_back_result_mux, RegExToMemOut);
    end

endmodule
