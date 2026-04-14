`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] a;
    reg [31:0] b;
    reg clk;
    reg res;
    wire [8:0] outp;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .clk(clk),
        .res(res),
        .outp(outp)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            res = 0;
            a = 0;
            b = 0;
            @(posedge clk);
            #1 res = 1;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;

            a = 32'h41000000;
            b = 32'h40000000;
            @(posedge clk);
            #2 #1;
 check_outputs(9'h002);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;

            a = 32'h40000000;
            b = 32'h41000000;
            @(posedge clk);
            #2 #1;
 check_outputs(9'h102);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;

            a = 32'h3F800000;
            b = 32'h3F800000;
            @(posedge clk);
            #2 #1;
 check_outputs(9'h000);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;

            a = 32'h7F800000;
            b = 32'h00000000;
            @(posedge clk);
            #2 #1;
 check_outputs(9'h0FF);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;

            a = 32'h00000000;
            b = 32'h7F800000;
            @(posedge clk);
            #2 #1;
 check_outputs(9'h1FF);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = test_num + 1;
            a = 32'h41000000;
            b = 32'h40000000;
            @(posedge clk);
            #1 res = 0;
            @(posedge clk);
            #2 #1;
 check_outputs(9'h000);
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
        input [8:0] expected_outp;
        begin
            if (expected_outp === (expected_outp ^ outp ^ expected_outp)) begin
                $display("PASS");
                $display("  Outputs: outp=%h",
                         outp);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: outp=%h",
                         expected_outp);
                $display("  Got:      outp=%h",
                         outp);
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
        $dumpvars(0,a, b, clk, res, outp);
    end

endmodule
