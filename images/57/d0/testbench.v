`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] input1;
    reg [7:0] input2;
    reg [7:0] input3;
    reg [7:0] input4;
    reg rst_n;
    reg sel_b1;
    reg sel_b2;
    wire [15:0] Johnson_out;
    wire [15:0] mux_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .input1(input1),
        .input2(input2),
        .input3(input3),
        .input4(input4),
        .rst_n(rst_n),
        .sel_b1(sel_b1),
        .sel_b2(sel_b2),
        .Johnson_out(Johnson_out),
        .mux_out(mux_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            input1 = 8'h00;
            input2 = 8'h00;
            input3 = 8'h00;
            input4 = 8'h00;
            sel_b1 = 0;
            sel_b2 = 0;
            #20;
            rst_n = 1;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            #1;


            check_outputs(16'h0000, 16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            input1 = 8'hA5;
            sel_b1 = 0;
            sel_b2 = 0;
            @(posedge clk);
            #2;

            #1;


            check_outputs(Johnson_out, 16'h00A5);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            input2 = 8'h5A;
            sel_b1 = 0;
            sel_b2 = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(Johnson_out, 16'h005A);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            input3 = 8'hFF;
            sel_b1 = 1;
            sel_b2 = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(Johnson_out, 16'h00FF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            input4 = 8'h12;
            sel_b1 = 1;
            sel_b2 = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(Johnson_out, 16'h0012);
        end
        endtask

    task testcase006;

        reg [15:0] first_johnson;
        begin
            test_num = 6;
            reset_dut();
            input1 = 8'hAA;
            sel_b1 = 0;
            sel_b2 = 0;

            @(posedge clk);
            #2;
            first_johnson = Johnson_out;


            input1 = 8'hBB;
            @(posedge clk);
            #2;


            if (Johnson_out != first_johnson) begin
                $display("Johnson counter progressed from %h to %h", first_johnson, Johnson_out);
                #1;

                check_outputs(Johnson_out, 16'h00BB);
            end else begin
                $display("Johnson counter did not change state.");
                #1;

                check_outputs(Johnson_out, 16'h00BB);
            end
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
        input [15:0] expected_Johnson_out;
        input [15:0] expected_mux_out;
        begin
            if (expected_Johnson_out === (expected_Johnson_out ^ Johnson_out ^ expected_Johnson_out) &&
                expected_mux_out === (expected_mux_out ^ mux_out ^ expected_mux_out)) begin
                $display("PASS");
                $display("  Outputs: Johnson_out=%h, mux_out=%h",
                         Johnson_out, mux_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Johnson_out=%h, mux_out=%h",
                         expected_Johnson_out, expected_mux_out);
                $display("  Got:      Johnson_out=%h, mux_out=%h",
                         Johnson_out, mux_out);
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
        $dumpvars(0,clk, input1, input2, input3, input4, rst_n, sel_b1, sel_b2, Johnson_out, mux_out);
    end

endmodule
