`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] in;
    reg reset;
    wire [31:0] and_out;
    wire or_out;
    wire [31:0] out;
    wire [7:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in(in),
        .reset(reset),
        .and_out(and_out),
        .or_out(or_out),
        .out(out),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            in = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Reset state and no-change...");
            test_num = test_num + 1;
            reset_dut();

            in = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'h0, 1'b0, 32'h0, 8'h0);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Shift register and or_out logic...");
            test_num = test_num + 1;
            reset_dut();


            in = 32'h1;
            @(posedge clk);
            #1;




            in = 32'h0;
            @(posedge clk);
            #1;
            in = 32'h0;
            @(posedge clk);
            #1;





            #1;






            check_outputs(32'h1, 1'b1, 32'h1, 8'h04);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Bitwise change accumulation...");
            test_num = test_num + 1;
            reset_dut();


            in = 32'hF0F0F0F0;
            @(posedge clk);
            #1;
            in = 32'hFFFFFFFF;
            @(posedge clk);
            #1;
            in = 32'hFFFFFFFF;
            @(posedge clk);
            #1;








            #1;









            check_outputs(32'hFFFFFFFF, 1'b1, 32'hFFFFFFFF, 8'h03);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: and_out behavior when or_out is 0...");
            test_num = test_num + 1;
            reset_dut();


            in = 32'hAAAAAAAA;
            @(posedge clk);
            #1;


            in = 32'h55555554;
            @(posedge clk);
            #1;


            repeat(8) begin
                in = 32'h0;
                @(posedge clk);
                #1;
            end



            #1;




            check_outputs(32'h0, 1'b0, 32'hFFFFFFFF, 8'h00);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Comprehensive sequence...");
            test_num = test_num + 1;
            reset_dut();


            in = 32'h80000000;
            @(posedge clk);
            #1;


            in = 32'h00000001;
            @(posedge clk);
            #1;


            in = 32'h0000FF01;
            @(posedge clk);
            #1;


            #1;



            check_outputs(32'h8000FF01, 1'b1, 32'h8000FF01, 8'h03);
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
        input [31:0] expected_and_out;
        input expected_or_out;
        input [31:0] expected_out;
        input [7:0] expected_q;
        begin
            if (expected_and_out === (expected_and_out ^ and_out ^ expected_and_out) &&
                expected_or_out === (expected_or_out ^ or_out ^ expected_or_out) &&
                expected_out === (expected_out ^ out ^ expected_out) &&
                expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: and_out=%h, or_out=%b, out=%h, q=%h",
                         and_out, or_out, out, q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: and_out=%h, or_out=%b, out=%h, q=%h",
                         expected_and_out, expected_or_out, expected_out, expected_q);
                $display("  Got:      and_out=%h, or_out=%b, out=%h, q=%h",
                         and_out, or_out, out, q);
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
        $dumpvars(0,clk, in, reset, and_out, or_out, out, q);
    end

endmodule
