`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] a;
    reg [7:0] b;
    reg clk;
    wire [7:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .clk(clk),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            a <= 8'h00;
            b <= 8'h00;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: 0x00 ^ 0x00", test_num);
            reset_dut();
            a <= 8'h00;
            b <= 8'h00;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: 0xFF ^ 0xFF", test_num);
            reset_dut();
            a <= 8'hFF;
            b <= 8'hFF;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: 0xFF ^ 0x00", test_num);
            reset_dut();
            a <= 8'hFF;
            b <= 8'h00;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: 0x55 ^ 0xAA", test_num);
            reset_dut();
            a <= 8'h55;
            b <= 8'hAA;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: 0x12 ^ 0x34", test_num);
            reset_dut();
            a <= 8'h12;
            b <= 8'h34;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'h26);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: 0x0F ^ 0xF0", test_num);
            reset_dut();
            a <= 8'h0F;
            b <= 8'hF0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: 0x80 ^ 0x01", test_num);
            reset_dut();
            a <= 8'h80;
            b <= 8'h01;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'h81);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: 0xCA ^ 0xFE", test_num);
            reset_dut();
            a <= 8'hCA;
            b <= 8'hFE;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'h34);
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
        input [7:0] expected_out;
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
        $dumpvars(0,a, b, clk, out);
    end

endmodule
