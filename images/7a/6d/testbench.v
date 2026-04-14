`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg a;
    reg b;
    reg clk;
    reg [7:0] d;
    reg reset;
    wire final_out;
    wire [7:0] reg_out;
    wire xnor_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .clk(clk),
        .d(d),
        .reset(reset),
        .final_out(final_out),
        .reg_out(reg_out),
        .xnor_out(xnor_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            a = 0;
            b = 0;
            d = 8'h00;
            reset = 1;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();



            #1;




            check_outputs(1'b0, 8'h34, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            d = 8'h01;
            a = 1;
            b = 1;
            @(posedge clk);
            #1;



            #1;




            check_outputs(1'b1, 8'h01, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            d = 8'h00;
            a = 0;
            b = 1;
            @(posedge clk);
            #1;



            #1;




            check_outputs(1'b1, 8'h00, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            d = 8'h01;
            a = 1;
            b = 0;
            @(posedge clk);
            #1;



            #1;




            check_outputs(1'b0, 8'h01, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            d = 8'hFF;
            a = 1;
            b = 1;
            @(posedge clk);
            #1;



            #1;




            check_outputs(1'b0, 8'hFF, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            d = 8'h01;
            a = 0;
            b = 0;
            @(posedge clk);
            #1;



            #1;




            check_outputs(1'b1, 8'h01, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();


            d = 8'h00;
            a = 1;
            b = 1;
            @(posedge clk);
            #1;


            a = 0;
            b = 1;
            #1;



            #1;




            check_outputs(1'b1, 8'h00, 1'b0);
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
        input expected_final_out;
        input [7:0] expected_reg_out;
        input expected_xnor_out;
        begin
            if (expected_final_out === (expected_final_out ^ final_out ^ expected_final_out) &&
                expected_reg_out === (expected_reg_out ^ reg_out ^ expected_reg_out) &&
                expected_xnor_out === (expected_xnor_out ^ xnor_out ^ expected_xnor_out)) begin
                $display("PASS");
                $display("  Outputs: final_out=%b, reg_out=%h, xnor_out=%b",
                         final_out, reg_out, xnor_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: final_out=%b, reg_out=%h, xnor_out=%b",
                         expected_final_out, expected_reg_out, expected_xnor_out);
                $display("  Got:      final_out=%b, reg_out=%h, xnor_out=%b",
                         final_out, reg_out, xnor_out);
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
        $dumpvars(0,a, b, clk, d, reset, final_out, reg_out, xnor_out);
    end

endmodule
