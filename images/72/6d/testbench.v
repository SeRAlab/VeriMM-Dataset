`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg clr;
    reg left_in;
    reg m0;
    reg m1;
    reg [3:0] p_in;
    reg right_in;
    wire left_out;
    wire [3:0] p_out;
    wire right_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .clr(clr),
        .left_in(left_in),
        .m0(m0),
        .m1(m1),
        .p_in(p_in),
        .right_in(right_in),
        .left_out(left_out),
        .p_out(p_out),
        .right_out(right_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            test_num = test_num + 1;
            clr = 1;
            m0 = 0;
            m1 = 0;
            left_in = 0;
            right_in = 0;
            p_in = 4'b0000;
            @(posedge clk);
            #1 clr = 0;
            $display("\nTest Case %0d Started", test_num);
        end
        endtask
    task testcase001;

        begin
            reset_dut();

            m0 = 1; m1 = 1;
            p_in = 4'b1011;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 4'b1011, 1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();

            m0 = 1; m1 = 1; p_in = 4'b1000;
            @(posedge clk);

            #1 m0 = 0; m1 = 1; left_in = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 4'b1100, 1'b0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();

            m0 = 1; m1 = 1; p_in = 4'b0001;
            @(posedge clk);

            #1 m0 = 1; m1 = 0; right_in = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 4'b0011, 1'b1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();

            m0 = 1; m1 = 1; p_in = 4'b1111;
            @(posedge clk);

            #1 clr = 1; m0 = 1; m1 = 0; right_in = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 4'b0000, 1'b0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();

            m0 = 0; m1 = 1; left_in = 1;
            repeat(4) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 4'b1111, 1'b1);
        end
        endtask

    task testcase006;

        begin
            reset_dut();

            m0 = 1; m1 = 0; right_in = 1;
            repeat(4) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 4'b1111, 1'b1);
        end
        endtask

    task testcase007;

        begin
            reset_dut();

            m0 = 1; m1 = 1; p_in = 4'b1010;
            @(posedge clk);

            #1 m0 = 0; m1 = 0;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 4'b1010, 1'b0);
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
        input expected_left_out;
        input [3:0] expected_p_out;
        input expected_right_out;
        begin
            if (expected_left_out === (expected_left_out ^ left_out ^ expected_left_out) &&
                expected_p_out === (expected_p_out ^ p_out ^ expected_p_out) &&
                expected_right_out === (expected_right_out ^ right_out ^ expected_right_out)) begin
                $display("PASS");
                $display("  Outputs: left_out=%b, p_out=%h, right_out=%b",
                         left_out, p_out, right_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: left_out=%b, p_out=%h, right_out=%b",
                         expected_left_out, expected_p_out, expected_right_out);
                $display("  Got:      left_out=%b, p_out=%h, right_out=%b",
                         left_out, p_out, right_out);
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
        $dumpvars(0,clk, clr, left_in, m0, m1, p_in, right_in, left_out, p_out, right_out);
    end

endmodule
