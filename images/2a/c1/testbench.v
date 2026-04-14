`timescale 1ns/1ps

module pipelined_processor_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] A;
    reg [7:0] B;
    reg CTRL;
    reg clk;
    reg rst;
    wire [7:0] RESULT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pipelined_processor dut (
        .A(A),
        .B(B),
        .CTRL(CTRL),
        .clk(clk),
        .rst(rst),
        .RESULT(RESULT)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            A = 0;
            B = 0;
            CTRL = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Simple Addition (10 + 20)", test_num);
            reset_dut();
            A = 8'd10;
            B = 8'd20;
            CTRL = 1'b0;
            @(posedge clk);

            repeat(7) @(posedge clk);
            #1;
            #1;

            check_outputs(8'd30);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Simple Subtraction (50 - 20)", test_num);
            reset_dut();
            A = 8'd50;
            B = 8'd20;
            CTRL = 1'b1;
            @(posedge clk);
            repeat(7) @(posedge clk);
            #1;
            #1;

            check_outputs(8'd30);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Addition with Overflow (200 + 100)", test_num);
            reset_dut();
            A = 8'd200;
            B = 8'd100;
            CTRL = 1'b0;
            @(posedge clk);
            repeat(7) @(posedge clk);
            #1;

            #1;


            check_outputs(8'd44);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Subtraction result negative (10 - 20)", test_num);
            reset_dut();
            A = 8'd10;
            B = 8'd20;
            CTRL = 1'b1;
            @(posedge clk);
            repeat(7) @(posedge clk);
            #1;

            #1;


            check_outputs(8'hF6);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Operations with Zero", test_num);
            reset_dut();
            A = 8'd0;
            B = 8'd0;
            CTRL = 1'b0;
            @(posedge clk);
            repeat(7) @(posedge clk);
            #1;
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Maximum values subtraction (255 - 255)", test_num);
            reset_dut();
            A = 8'hFF;
            B = 8'hFF;
            CTRL = 1'b1;
            @(posedge clk);
            repeat(7) @(posedge clk);
            #1;
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Maximum values addition (255 + 255)", test_num);
            reset_dut();
            A = 8'hFF;
            B = 8'hFF;
            CTRL = 1'b0;
            @(posedge clk);
            repeat(7) @(posedge clk);
            #1;

            #1;


            check_outputs(8'hFE);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("pipelined_processor Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
        input [7:0] expected_RESULT;
        begin
            if (expected_RESULT === (expected_RESULT ^ RESULT ^ expected_RESULT)) begin
                $display("PASS");
                $display("  Outputs: RESULT=%h",
                         RESULT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: RESULT=%h",
                         expected_RESULT);
                $display("  Got:      RESULT=%h",
                         RESULT);
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
        $dumpvars(0,A, B, CTRL, clk, rst, RESULT);
    end

endmodule
