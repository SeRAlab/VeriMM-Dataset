`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] ALU2_in;
    reg [31:0] ReadData_in;
    reg [1:0] WB3_in;
    reg clk;
    reg [4:0] instruction_mux2_in;
    reg reset;
    wire [31:0] ALU2_out;
    wire [31:0] ReadData_out;
    wire [1:0] WB3_out;
    wire [4:0] instruction_mux2_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ALU2_in(ALU2_in),
        .ReadData_in(ReadData_in),
        .WB3_in(WB3_in),
        .clk(clk),
        .instruction_mux2_in(instruction_mux2_in),
        .reset(reset),
        .ALU2_out(ALU2_out),
        .ReadData_out(ReadData_out),
        .WB3_out(WB3_out),
        .instruction_mux2_out(instruction_mux2_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(negedge clk);
            reset = 1;
            WB3_in = 2'b0;
            ReadData_in = 32'b0;
            ALU2_in = 32'b0;
            instruction_mux2_in = 5'b0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Synchronous Reset Check", test_num);


            @(negedge clk);
            reset = 1;
            WB3_in = 2'b11;
            ReadData_in = 32'hFFFFFFFF;
            ALU2_in = 32'hFFFFFFFF;
            instruction_mux2_in = 5'h1F;

            @(posedge clk);
            #2;
            reset = 0;


            #1;



            check_outputs(32'h0, 32'h0, 2'h0, 5'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Basic Data Capture", test_num);
            reset_dut();

            @(negedge clk);
            WB3_in = 2'b10;
            ReadData_in = 32'h12345678;
            ALU2_in = 32'h87654321;
            instruction_mux2_in = 5'h0A;

            @(posedge clk);
            #2;
            #1;

            check_outputs(32'h87654321, 32'h12345678, 2'b10, 5'h0A);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: All Bits Toggling", test_num);
            reset_dut();

            @(negedge clk);
            WB3_in = 2'b11;
            ReadData_in = 32'hFFFFFFFF;
            ALU2_in = 32'hAAAAAAAA;
            instruction_mux2_in = 5'h1F;

            @(posedge clk);
            #2;


            if (ALU2_out !== 32'hAAAAAAAA) begin
                $display("Mid-test failure: Set 1 didn't latch.");
            end

            @(negedge clk);
            WB3_in = 2'b00;
            ReadData_in = 32'h00000000;
            ALU2_in = 32'h55555555;
            instruction_mux2_in = 5'h00;

            @(posedge clk);
            #2;
            #1;

            check_outputs(32'h55555555, 32'h00000000, 2'b00, 5'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Random Pattern Verification", test_num);
            reset_dut();

            @(negedge clk);
            WB3_in = 2'b01;
            ReadData_in = 32'hDEADBEEF;
            ALU2_in = 32'hCAFEBABE;
            instruction_mux2_in = 5'h15;

            @(posedge clk);
            #2;
            #1;

            check_outputs(32'hCAFEBABE, 32'hDEADBEEF, 2'b01, 5'h15);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Data Hold and Update", test_num);
            reset_dut();

            @(negedge clk);
            WB3_in = 2'b11;
            ReadData_in = 32'h55AA55AA;
            ALU2_in = 32'hCC33CC33;
            instruction_mux2_in = 5'h07;

            @(posedge clk);
            #2;


            @(negedge clk);
            WB3_in = 2'b00;
            ReadData_in = 32'h0;

            #1;
            if (WB3_out !== 2'b11 || ReadData_out !== 32'h55AA55AA) begin
                $display("FAIL: Output changed before clock edge");
            end

            @(posedge clk);
            #2;
            #1;

            check_outputs(32'hCC33CC33, 32'h0, 2'b00, 5'h07);
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
        input [31:0] expected_ALU2_out;
        input [31:0] expected_ReadData_out;
        input [1:0] expected_WB3_out;
        input [4:0] expected_instruction_mux2_out;
        begin
            if (expected_ALU2_out === (expected_ALU2_out ^ ALU2_out ^ expected_ALU2_out) &&
                expected_ReadData_out === (expected_ReadData_out ^ ReadData_out ^ expected_ReadData_out) &&
                expected_WB3_out === (expected_WB3_out ^ WB3_out ^ expected_WB3_out) &&
                expected_instruction_mux2_out === (expected_instruction_mux2_out ^ instruction_mux2_out ^ expected_instruction_mux2_out)) begin
                $display("PASS");
                $display("  Outputs: ALU2_out=%h, ReadData_out=%h, WB3_out=%h, instruction_mux2_out=%h",
                         ALU2_out, ReadData_out, WB3_out, instruction_mux2_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ALU2_out=%h, ReadData_out=%h, WB3_out=%h, instruction_mux2_out=%h",
                         expected_ALU2_out, expected_ReadData_out, expected_WB3_out, expected_instruction_mux2_out);
                $display("  Got:      ALU2_out=%h, ReadData_out=%h, WB3_out=%h, instruction_mux2_out=%h",
                         ALU2_out, ReadData_out, WB3_out, instruction_mux2_out);
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
        $dumpvars(0,ALU2_in, ReadData_in, WB3_in, clk, instruction_mux2_in, reset, ALU2_out, ReadData_out, WB3_out, instruction_mux2_out);
    end

endmodule
