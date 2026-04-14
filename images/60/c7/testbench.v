`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] a;
    reg [31:0] b;
    reg ce;
    reg clk;
    wire [47:0] p;

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
            a <= 0;
            b <= 0;
            ce <= 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            a <= 16'd123;
            b <= 32'd456;
            ce <= 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(48'd56088);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            a <= 16'hFFFF;
            b <= 32'd0;
            ce <= 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(48'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            a <= 16'hFFFF;
            b <= 32'hFFFFFFFF;
            ce <= 1;
            @(posedge clk);
            #2;


            #1;



            check_outputs(48'hFFFEFFFF0001);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();


            a <= 16'd10;
            b <= 32'd10;
            ce <= 1;
            @(posedge clk);
            #2;


            a <= 16'd50;
            b <= 32'd50;
            ce <= 0;
            @(posedge clk);
            #2;


            #1;



            check_outputs(48'd100);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            a <= 16'h0100;
            b <= 32'h00010000;
            ce <= 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(48'h000001000000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_dut();
            a <= 16'd2;
            b <= 32'h7FFFFFFF;
            ce <= 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(48'h0000FFFEFFFFFE);
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
        input [47:0] expected_p;
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
