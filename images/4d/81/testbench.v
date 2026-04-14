`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] a;
    reg [31:0] b;
    reg ce;
    reg clk;
    wire [31:0] p;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .ce(ce),
        .clk(clk),
        .p(p)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            a <= 32'd0;
            b <= 32'd0;
            ce <= 1'b1;
            repeat(6) @(posedge clk);
            ce <= 1'b0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Test %03d: Positive * Positive (12 * 10)", test_num);
            a <= 32'sd12;
            b <= 32'sd10;
            ce <= 1'b1;
            @(posedge clk);
            ce <= 1'b0;
            repeat(4) @(posedge clk);
            #1;

            check_outputs(32'sd120);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Test %03d: Positive * Negative (25 * -4)", test_num);
            a <= 32'sd25;
            b <= -32'sd4;
            ce <= 1'b1;
            repeat(5) @(posedge clk);
            ce <= 1'b0;
            #1;

            check_outputs(-32'sd100);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Test %03d: Negative * Negative (-7 * -8)", test_num);
            a <= -32'sd7;
            b <= -32'sd8;
            ce <= 1'b1;
            repeat(5) @(posedge clk);
            ce <= 1'b0;
            #1;

            check_outputs(32'sd56);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Test %03d: Multiplication by Zero (0 * -1234)", test_num);
            a <= 32'sd0;
            b <= -32'sd1234;
            ce <= 1'b1;
            repeat(5) @(posedge clk);
            ce <= 1'b0;
            #1;

            check_outputs(32'sd0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Test %03d: Max Positive * 2 (Truncation Check)", test_num);
            a <= 32'h7FFFFFFF;
            b <= 32'sd2;
            ce <= 1'b1;
            repeat(5) @(posedge clk);
            ce <= 1'b0;

            #1;


            check_outputs(32'hFFFFFFFE);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("Test %03d: Identity (-1 * 1)", test_num);
            a <= -32'sd1;
            b <= 32'sd1;
            ce <= 1'b1;
            repeat(5) @(posedge clk);
            ce <= 1'b0;
            #1;

            check_outputs(-32'sd1);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;
            $display("Test %03d: Clock Enable Gating Test", test_num);

            a <= 32'sd9;
            b <= 32'sd9;
            ce <= 1'b1;
            @(posedge clk);

            ce <= 1'b0;
            repeat(5) @(posedge clk);

            ce <= 1'b1;
            repeat(4) @(posedge clk);
            #1;

            check_outputs(32'sd81);
        end
        endtask

    task testcase008;

        integer i;
        begin
            reset_dut();
            test_num = 8;
            $display("Test %03d: Pipelined Back-to-Back Test", test_num);


            ce <= 1'b1;
            for (i = 1; i <= 5; i = i + 1) begin
                a <= i;
                b <= 32'sd2;
                @(posedge clk);
            end



            #1;




            check_outputs(32'sd2);
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
        input [31:0] expected_p;
        begin
            if (expected_p === (expected_p ^ p ^ expected_p)) begin
                $display("PASS");
                $display("  Outputs: p=%h",
                         p);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: p=%h",
                         expected_p);
                $display("  Got:      p=%h",
                         p);
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
        $dumpvars(0,a, b, ce, clk, p);
    end

endmodule
