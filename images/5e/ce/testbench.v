`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] a;
    reg [7:0] b;
    reg clk;
    reg [2:0] op;
    reg rst;
    wire of;
    wire [7:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .clk(clk),
        .op(op),
        .rst(rst),
        .of(of),
        .result(result)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            a = 0;
            b = 0;
            op = 0;
            @(posedge clk);
            #1;
            rst = 0;
        end
        endtask
    task testcase001;

        begin
            reset_dut();


            #1;



            check_outputs(1'b0, 8'h00);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            a = 8'sd10; b = 8'sd20; op = ADD;
            @(posedge clk); #1;
            #1;

            check_outputs(1'b0, 8'sd30);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            a = 8'sd100; b = 8'sd50; op = ADD;
            @(posedge clk); #1;

            #1;


            check_outputs(1'b1, 8'b10010110);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            a = -8'sd100; b = -8'sd40; op = ADD;
            @(posedge clk); #1;

            #1;


            check_outputs(1'b1, 8'b01110100);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            a = 8'sd50; b = 8'sd20; op = SUB;
            @(posedge clk); #1;
            #1;

            check_outputs(1'b0, 8'sd30);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            a = 8'sd100; b = -8'sd50; op = SUB;
            @(posedge clk); #1;
            #1;

            check_outputs(1'b1, 8'b10010110);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            a = 8'sd10; b = 8'sd12; op = MUL;
            @(posedge clk); #1;
            #1;

            check_outputs(1'b0, 8'sd120);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            a = 8'sd20; b = 8'sd10; op = MUL;
            @(posedge clk); #1;

            #1;


            check_outputs(1'b1, 8'b11001000);
        end
        endtask

    task testcase009;

        begin
            reset_dut();
            a = 8'sd40; b = 8'sd8; op = DIV;
            @(posedge clk); #1;
            #1;

            check_outputs(1'b0, 8'sd5);
        end
        endtask

    task testcase010;

        begin
            reset_dut();
            a = 8'sd50; b = 8'sd0; op = DIV;
            @(posedge clk); #1;


            #1;



            check_outputs(1'b0, 8'sd0);
        end
        endtask

    task testcase011;

        begin
            reset_dut();
            a = -8'sd128; b = -8'sd1; op = DIV;
            @(posedge clk); #1;

            #1;


            check_outputs(1'b1, -8'sd128);
        end
        endtask

    task testcase012;

        begin
            reset_dut();
            a = -8'sd100; b = 8'sd40; op = SUB;
            @(posedge clk); #1;
            #1;

            check_outputs(1'b1, 8'b01110100);
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
        testcase009();
        testcase010();
        testcase011();
        testcase012();
        
        
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
        input expected_of;
        input [7:0] expected_result;
        begin
            if (expected_of === (expected_of ^ of ^ expected_of) &&
                expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: of=%b, result=%h",
                         of, result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: of=%b, result=%h",
                         expected_of, expected_result);
                $display("  Got:      of=%b, result=%h",
                         of, result);
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
        $dumpvars(0,a, b, clk, op, rst, of, result);
    end

endmodule
