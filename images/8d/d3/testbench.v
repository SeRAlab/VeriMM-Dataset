`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] BRegister_in;
    reg clk;
    reg clr_;
    reg lb_;
    wire [7:0] BRegister_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .BRegister_in(BRegister_in),
        .clk(clk),
        .clr_(clr_),
        .lb_(lb_),
        .BRegister_out(BRegister_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(negedge clk);
            clr_ = 0;
            lb_ = 1;
            BRegister_in = 8'h00;
            @(negedge clk);
            clr_ = 1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            @(negedge clk);
            BRegister_in = 8'hA5;
            lb_ = 0;
            @(negedge clk);
            lb_ = 1;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            @(negedge clk);
            BRegister_in = 8'h55;
            lb_ = 0;
            @(negedge clk);
            lb_ = 1;
            BRegister_in = 8'hFF;
            @(negedge clk);
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            @(negedge clk);
            clr_ = 0;
            lb_ = 0;
            BRegister_in = 8'hFF;
            @(negedge clk);
            clr_ = 1;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();

            @(negedge clk);
            lb_ = 0; BRegister_in = 8'hAA;
            @(negedge clk);

            BRegister_in = 8'h00;
            lb_ = 0;
            clr_ = 1;
            @(negedge clk);
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            @(negedge clk);
            lb_ = 0;
            BRegister_in = 8'h12;
            @(negedge clk);
            BRegister_in = 8'h34;
            @(negedge clk);
            BRegister_in = 8'h78;
            @(negedge clk);
            lb_ = 1;
            #1;

            check_outputs(8'h78);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            @(negedge clk);
            lb_ = 0;
            BRegister_in = 8'hFF;
            @(negedge clk);
            lb_ = 1;
            #1;

            check_outputs(8'hFF);
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
        input [7:0] expected_BRegister_out;
        begin
            if (expected_BRegister_out === (expected_BRegister_out ^ BRegister_out ^ expected_BRegister_out)) begin
                $display("PASS");
                $display("  Outputs: BRegister_out=%h",
                         BRegister_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: BRegister_out=%h",
                         expected_BRegister_out);
                $display("  Got:      BRegister_out=%h",
                         BRegister_out);
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
        $dumpvars(0,BRegister_in, clk, clr_, lb_, BRegister_out);
    end

endmodule
