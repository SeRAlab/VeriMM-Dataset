`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [2:0] a;
    reg [2:0] b;
    reg clk;
    reg d;
    wire [5:0] out_not;
    wire [2:0] out_or_bitwise;
    wire out_or_logical;
    wire q;

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
        .out_not(out_not),
        .out_or_bitwise(out_or_bitwise),
        .out_or_logical(out_or_logical),
        .q(q)
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
            d = 0;
            repeat(4) @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            $display("Running testcase001...");

            a = 3'b101; b = 3'b011;
            d = 1; @(posedge clk);
            d = 0; @(posedge clk);
            d = 0; @(posedge clk);
            #1;




            #1;





            check_outputs(6'b010100, 3'b111, 1'b1, 1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            $display("Running testcase002...");

            a = 3'b000; b = 3'b000;
            d = 0; @(posedge clk);
            d = 0; @(posedge clk);
            d = 0; @(posedge clk);
            #1;




            #1;





            check_outputs(6'b111111, 3'b000, 1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            $display("Running testcase003...");

            a = 3'b111; b = 3'b111;
            d = 1; @(posedge clk);
            d = 1; @(posedge clk);
            d = 1; @(posedge clk);
            #1;




            #1;





            check_outputs(6'b000000, 3'b111, 1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            $display("Running testcase004...");

            a = 3'b010; b = 3'b100;
            d = 1; @(posedge clk);
            d = 0; @(posedge clk);
            d = 1; @(posedge clk);
            #1;




            #1;





            check_outputs(6'b101011, 3'b110, 1'b1, 1'b1);
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
        input [5:0] expected_out_not;
        input [2:0] expected_out_or_bitwise;
        input expected_out_or_logical;
        input expected_q;
        begin
            if (expected_out_not === (expected_out_not ^ out_not ^ expected_out_not) &&
                expected_out_or_bitwise === (expected_out_or_bitwise ^ out_or_bitwise ^ expected_out_or_bitwise) &&
                expected_out_or_logical === (expected_out_or_logical ^ out_or_logical ^ expected_out_or_logical) &&
                expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: out_not=%h, out_or_bitwise=%h, out_or_logical=%b, q=%b",
                         out_not, out_or_bitwise, out_or_logical, q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_not=%h, out_or_bitwise=%h, out_or_logical=%b, q=%b",
                         expected_out_not, expected_out_or_bitwise, expected_out_or_logical, expected_q);
                $display("  Got:      out_not=%h, out_or_bitwise=%h, out_or_logical=%b, q=%b",
                         out_not, out_or_bitwise, out_or_logical, q);
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
        $dumpvars(0,a, b, clk, d, out_not, out_or_bitwise, out_or_logical, q);
    end

endmodule
