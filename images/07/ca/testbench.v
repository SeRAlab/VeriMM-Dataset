`timescale 1ns/1ps

module pipeline_2stage_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] a;
    reg [3:0] b;
    reg clk;
    reg [3:0] constant;
    wire [3:0] stage1_out;
    wire [3:0] stage2_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pipeline_2stage dut (
        .a(a),
        .b(b),
        .clk(clk),
        .constant(constant),
        .stage1_out(stage1_out),
        .stage2_out(stage2_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            a = 0;
            b = 0;
            constant = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Running Testcase 001: Basic operation (5+3-2)");
            a = 4'd5;
            b = 4'd3;
            constant = 4'd2;


            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(4'd8, 4'd6);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Running Testcase 002: Addition overflow (12+5-1)");
            a = 4'd12;
            b = 4'd5;
            constant = 4'd1;

            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(4'd1, 4'd0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Running Testcase 003: Subtraction underflow (1+1-5)");
            a = 4'd1;
            b = 4'd1;
            constant = 4'd5;

            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(4'd2, 4'd13);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Running Testcase 004: Zero inputs");
            a = 4'd0;
            b = 4'd0;
            constant = 4'd0;

            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(4'd0, 4'd0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Running Testcase 005: Max inputs (15+15-15)");
            a = 4'd15;
            b = 4'd15;
            constant = 4'd15;

            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(4'd14, 4'd15);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("pipeline_2stage Testbench");
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
        input [3:0] expected_stage1_out;
        input [3:0] expected_stage2_out;
        begin
            if (expected_stage1_out === (expected_stage1_out ^ stage1_out ^ expected_stage1_out) &&
                expected_stage2_out === (expected_stage2_out ^ stage2_out ^ expected_stage2_out)) begin
                $display("PASS");
                $display("  Outputs: stage1_out=%h, stage2_out=%h",
                         stage1_out, stage2_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: stage1_out=%h, stage2_out=%h",
                         expected_stage1_out, expected_stage2_out);
                $display("  Got:      stage1_out=%h, stage2_out=%h",
                         stage1_out, stage2_out);
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
        $dumpvars(0,a, b, clk, constant, stage1_out, stage2_out);
    end

endmodule
