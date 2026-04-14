`timescale 1ns/1ps

module and_pipe_32bit_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] and_a;
    reg [31:0] and_b;
    reg clk;
    reg i_en;
    reg rst_n;
    wire o_en;
    wire [31:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    and_pipe_32bit dut (
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
            and_a = 0;
            and_b = 0;
            repeat(2) @(posedge clk);
            #1 rst_n = 1;
            repeat(1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning Testcase 001: All High Bits");
            reset_dut();
            test_num = 1;

            @(negedge clk);
            and_a = 32'hFFFFFFFF;
            and_b = 32'hFFFFFFFF;
            i_en = 1;

            @(posedge clk);
            #1 i_en = 0;


            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(1, 32'hFFFFFFFF);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning Testcase 002: All Zeros");
            reset_dut();
            test_num = 2;

            @(negedge clk);
            and_a = 32'h00000000;
            and_b = 32'hFFFFFFFF;
            i_en = 1;

            @(posedge clk);
            #1 i_en = 0;

            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(1, 32'h00000000);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning Testcase 003: Complementary Patterns");
            reset_dut();
            test_num = 3;

            @(negedge clk);
            and_a = 32'hAAAAAAAA;
            and_b = 32'h55555555;
            i_en = 1;

            @(posedge clk);
            #1 i_en = 0;

            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(1, 32'h00000000);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning Testcase 004: Random Pattern 1");
            reset_dut();
            test_num = 4;

            @(negedge clk);
            and_a = 32'h12345678;
            and_b = 32'hF0F0F0F0;
            i_en = 1;

            @(posedge clk);
            #1 i_en = 0;

            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(1, (32'h12345678 & 32'hF0F0F0F0));
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning Testcase 005: Random Pattern 2");
            reset_dut();
            test_num = 5;

            @(negedge clk);
            and_a = 32'hABCDDCCA;
            and_b = 32'hFFFF0000;
            i_en = 1;

            @(posedge clk);
            #1 i_en = 0;

            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(1, (32'hABCDDCCA & 32'hFFFF0000));
        end
        endtask

    task testcase006;

        begin
            $display("\nRunning Testcase 006: Enable Disabled Check");
            reset_dut();
            test_num = 6;

            @(negedge clk);
            and_a = 32'hFFFFFFFF;
            and_b = 32'hFFFFFFFF;
            i_en = 0;

            repeat(3) @(posedge clk);
            #1;

            #1;


            check_outputs(0, 32'h00000000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("and_pipe_32bit Testbench");
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
        input [31:0] expected_result;
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
