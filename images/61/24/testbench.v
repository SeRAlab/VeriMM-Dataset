`timescale 1ns/1ps

module and_gate_pipe_4bit_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] and_a;
    reg [3:0] and_b;
    reg clk;
    reg i_en;
    reg rst_n;
    wire o_en;
    wire [3:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    and_gate_pipe_4bit dut (
        .and_a(and_a),
        .and_b(and_b),
        .clk(clk),
        .i_en(i_en),
        .rst_n(rst_n),
        .o_en(o_en),
        .result(result)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            i_en = 0;
            and_a = 4'b0;
            and_b = 4'b0;
            repeat(2) @(posedge clk);
            #1 rst_n = 1;
            repeat(1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase 001: Basic AND operation (1010 & 1100)");
            and_a = 4'b1010;
            and_b = 4'b1100;
            i_en = 1;
            @(posedge clk);
            i_en = 0;

            repeat(2) @(posedge clk);
            #1 #1;
 check_outputs(1'b1, 4'b1000);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase 002: Identity operation (1111 & 1111)");
            and_a = 4'b1111;
            and_b = 4'b1111;
            i_en = 1;
            @(posedge clk);
            i_en = 0;
            repeat(2) @(posedge clk);
            #1 #1;
 check_outputs(1'b1, 4'b1111);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase 003: Zero operation (1111 & 0000)");
            and_a = 4'b1111;
            and_b = 4'b0000;
            i_en = 1;
            @(posedge clk);
            i_en = 0;
            repeat(2) @(posedge clk);
            #1 #1;
 check_outputs(1'b1, 4'b0000);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase 004: Alternating bits (1010 & 0101)");
            and_a = 4'b1010;
            and_b = 4'b0101;
            i_en = 1;
            @(posedge clk);
            i_en = 0;
            repeat(2) @(posedge clk);
            #1 #1;
 check_outputs(1'b1, 4'b0000);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase 005: Disable check (i_en = 0)");
            and_a = 4'b1111;
            and_b = 4'b1111;
            i_en = 0;
            @(posedge clk);
            repeat(2) @(posedge clk);
            #1 #1;
 check_outputs(1'b0, 4'b0000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("and_gate_pipe_4bit Testbench");
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
        input expected_o_en;
        input [3:0] expected_result;
        begin
            if (expected_o_en === (expected_o_en ^ o_en ^ expected_o_en) &&
                expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: o_en=%b, result=%h",
                         o_en, result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o_en=%b, result=%h",
                         expected_o_en, expected_result);
                $display("  Got:      o_en=%b, result=%h",
                         o_en, result);
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
        $dumpvars(0,and_a, and_b, clk, i_en, rst_n, o_en, result);
    end

endmodule
