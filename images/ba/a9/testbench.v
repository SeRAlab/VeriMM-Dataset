`timescale 1ns/1ps

module subtractor_pipe_4bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg i_en;
    reg rst_n;
    reg [3:0] sub_a;
    reg [3:0] sub_b;
    wire o_en;
    wire [3:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    subtractor_pipe_4bit dut (
        .clk(clk),
        .i_en(i_en),
        .rst_n(rst_n),
        .sub_a(sub_a),
        .sub_b(sub_b),
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
            sub_a = 0;
            sub_b = 0;
            repeat(2) @(posedge clk);
            #1 rst_n = 1;
            repeat(1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case 001: Basic Subtraction (10 - 4)");
            reset_dut();
            @(posedge clk);
            #1;
            sub_a = 4'd10;
            sub_b = 4'd4;
            i_en = 1'b1;
            @(posedge clk);
            #1;
            i_en = 1'b0;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 4'd6);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case 002: Zero Result (7 - 7)");
            reset_dut();
            @(posedge clk);
            #1;
            sub_a = 4'd7;
            sub_b = 4'd7;
            i_en = 1'b1;
            @(posedge clk);
            #1;
            i_en = 1'b0;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 4'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case 003: Underflow (2 - 5)");
            reset_dut();
            @(posedge clk);
            #1;
            sub_a = 4'd2;
            sub_b = 4'd5;
            i_en = 1'b1;
            @(posedge clk);
            #1;
            i_en = 1'b0;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 4'd13);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case 004: Max Values (15 - 0)");
            reset_dut();
            @(posedge clk);
            #1;
            sub_a = 4'd15;
            sub_b = 4'd0;
            i_en = 1'b1;
            @(posedge clk);
            #1;
            i_en = 1'b0;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 4'd15);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case 005: Wrap-around (0 - 1)");
            reset_dut();
            @(posedge clk);
            #1;
            sub_a = 4'd0;
            sub_b = 4'd1;
            i_en = 1'b1;
            @(posedge clk);
            #1;
            i_en = 1'b0;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 4'd15);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case 006: i_en Low Check");
            reset_dut();
            @(posedge clk);
            #1;
            sub_a = 4'd10;
            sub_b = 4'd2;
            i_en = 1'b0;
            repeat(3) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, result);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("subtractor_pipe_4bit Testbench");
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
        $dumpvars(0,clk, i_en, rst_n, sub_a, sub_b, o_en, result);
    end

endmodule
