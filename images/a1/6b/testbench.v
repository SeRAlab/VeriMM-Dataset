`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg clk;
    reg [3:0] in;
    reg [2:0] opcode;
    reg reset;
    reg select;
    wire [5:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .clk(clk),
        .in(in),
        .opcode(opcode),
        .reset(reset),
        .select(select),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            A = 0; B = 0; opcode = 0; select = 0; in = 0;
            @(posedge clk);
            #1 reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset = 1;
            A = 4'hF; B = 4'hF; select = 1; opcode = 3'b000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(6'b000000);
            reset = 0;
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            A = 4'd5; B = 4'd3; select = 1; opcode = 3'b000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(6'd8);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            A = 4'd10; B = 4'd4; select = 1; opcode = 3'b001;
            @(posedge clk);
            #1;
            #1;

            check_outputs(6'd6);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            A = 4'b1100; B = 4'b1010; select = 1; opcode = 3'b010;
            @(posedge clk);
            #1;
            #1;

            check_outputs(6'b001000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            A = 4'b1100; B = 4'b1010; select = 1; opcode = 3'b011;
            @(posedge clk);
            #1;
            #1;

            check_outputs(6'b001110);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            A = 4'b1100; B = 4'b1010; select = 1; opcode = 3'b100;
            @(posedge clk);
            #1;
            #1;

            check_outputs(6'b000110);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            A = 4'b1010; select = 1; opcode = 3'b101;
            @(posedge clk);
            #1;
            #1;

            check_outputs(6'b000101);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            reset_dut();
            A = 4'b1000; B = 4'b1111; select = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(6'b100000);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            reset_dut();
            A = 4'b0000; B = 4'b1000; select = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(6'b000010);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            reset_dut();
            A = 4'b0010; B = 4'b1000; select = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(6'b001000);
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
        testcase008();
        testcase009();
        testcase010();
        
        
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
        input [5:0] expected_out;
        begin
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
        $dumpvars(0,A, B, clk, in, opcode, reset, select, out);
    end

endmodule
