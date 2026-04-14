`timescale 1ns/1ps

module pipelined_multiplier_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] a;
    reg [3:0] b;
    reg clk;
    wire [7:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pipelined_multiplier dut (
        .a(a),
        .b(b),
        .clk(clk),
        .result(result)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            a <= 4'd0;
            b <= 4'd0;

            repeat (3) @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Zero Multiplication (0 x 0)", test_num);
            reset_dut();
            a <= 4'd0;
            b <= 4'd0;
            @(posedge clk);
            a <= 4'd15;
            b <= 4'd15;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Maximum Values (15 x 15)", test_num);
            reset_dut();
            a <= 4'd15;
            b <= 4'd15;
            @(posedge clk);
            a <= 4'd0;
            b <= 4'd0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd225);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Identity Multiplication (12 x 1)", test_num);
            reset_dut();
            a <= 4'd12;
            b <= 4'd1;
            @(posedge clk);
            a <= 4'd5;
            b <= 4'd5;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd12);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Standard Multiplication (7 x 3)", test_num);
            reset_dut();
            a <= 4'd7;
            b <= 4'd3;
            @(posedge clk);
            a <= 4'd0;
            b <= 4'd0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd21);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Power of Two (8 x 8)", test_num);
            reset_dut();
            a <= 4'd8;
            b <= 4'd8;
            @(posedge clk);
            a <= 4'd1;
            b <= 4'd1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd64);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Large result (10 x 14)", test_num);
            reset_dut();
            a <= 4'd10;
            b <= 4'd14;
            @(posedge clk);
            a <= 4'd2;
            b <= 4'd2;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd140);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("pipelined_multiplier Testbench");
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
        input [7:0] expected_result;
        begin
            if (expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: result=%h",
                         result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result=%h",
                         expected_result);
                $display("  Got:      result=%h",
                         result);
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
        $dumpvars(0,a, b, clk, result);
    end

endmodule
