`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [30:0] a;
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
            ce <= 0;
            a <= 0;
            b <= 0;
            @(posedge clk);
            @(negedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            a <= 31'd0;
            b <= 32'd0;
            ce <= 1;
            repeat(4) @(posedge clk);
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            a <= 31'd123;
            b <= 32'd1;
            ce <= 1;
            repeat(4) @(posedge clk);
            #1;

            check_outputs(32'd123);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            a <= 31'd10;
            b <= -32'd1;
            ce <= 1;
            repeat(4) @(posedge clk);
            #1;

            check_outputs(-32'd10);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            a <= 31'h7FFFFFFF;
            b <= 32'd2;
            ce <= 1;
            repeat(4) @(posedge clk);
            #1;

            check_outputs(32'hFFFFFFFE);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            a <= 31'h7FFFFFFF;
            b <= -32'd1;
            ce <= 1;
            repeat(4) @(posedge clk);
            #1;

            check_outputs(32'h80000001);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            a <= 31'd65536;
            b <= 32'd32768;
            ce <= 1;
            repeat(4) @(posedge clk);
            #1;

            check_outputs(32'h80000000);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            a <= 31'h7FFFFFFF;
            b <= 32'd0;
            ce <= 1;
            repeat(4) @(posedge clk);
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            reset_dut();

            a <= 31'd5; b <= 32'd5; ce <= 1;
            repeat(4) @(posedge clk);

            a <= 31'd10; b <= 32'd10; ce <= 0;
            repeat(4) @(posedge clk);

            #1;


            check_outputs(32'd25);
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
