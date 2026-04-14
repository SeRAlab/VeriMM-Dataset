`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [1:0] bank;
    reg clk;
    reg cs;
    reg dlast;
    reg drun_rd;
    reg drun_wr;
    reg init;
    reg rst;
    wire [8:0] a;
    wire done;
    wire en;
    wire we;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .bank(bank),
        .clk(clk),
        .cs(cs),
        .dlast(dlast),
        .drun_rd(drun_rd),
        .drun_wr(drun_wr),
        .init(init),
        .rst(rst),
        .a(a),
        .done(done),
        .en(en),
        .we(we)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            init = 0;
            cs = 0;
            bank = 2'b00;
            drun_rd = 0;
            drun_wr = 0;
            dlast = 0;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            #1;


            check_outputs(9'h000, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            init = 1;
            @(posedge clk);
            #2 init = 0;
            @(posedge clk);

            #1;


            check_outputs(9'h000, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            cs = 1;
            bank = 2'b01;
            drun_wr = 1;
            @(posedge clk);
            #2;

            #1;


            check_outputs(a, 1'b0, 1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            cs = 1;
            bank = 2'b10;
            drun_rd = 1;
            @(posedge clk);
            #2;

            #1;


            check_outputs(a, 1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            cs = 1;
            bank = 2'b00;
            drun_wr = 1;
            repeat(5) @(posedge clk);
            #2;


            if (a > 0)
                #1;

                check_outputs(a, 1'b0, 1'b1, 1'b1);
            else
                $display("FAIL: Address did not increment");
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            cs = 1;
            drun_rd = 1;
            @(posedge clk);
            dlast = 1;
            @(posedge clk);
            #2;

            #1;


            check_outputs(a, 1'b1, 1'b1, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            cs = 0;
            drun_wr = 1;
            @(posedge clk);
            #2;

            #1;


            check_outputs(9'h000, 1'b0, 1'b0, 1'b0);
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
        input [8:0] expected_a;
        input expected_done;
        input expected_en;
        input expected_we;
        begin
            if (expected_a === (expected_a ^ a ^ expected_a) &&
                expected_done === (expected_done ^ done ^ expected_done) &&
                expected_en === (expected_en ^ en ^ expected_en) &&
                expected_we === (expected_we ^ we ^ expected_we)) begin
                $display("PASS");
                $display("  Outputs: a=%h, done=%b, en=%b, we=%b",
                         a, done, en, we);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: a=%h, done=%b, en=%b, we=%b",
                         expected_a, expected_done, expected_en, expected_we);
                $display("  Got:      a=%h, done=%b, en=%b, we=%b",
                         a, done, en, we);
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
        $dumpvars(0,bank, clk, cs, dlast, drun_rd, drun_wr, init, rst, a, done, en, we);
    end

endmodule
