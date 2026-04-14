`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] b;
    reg clk;
    reg [13:0] e;
    reg reset;
    wire [13:0] q;
    wire rb;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .b(b),
        .clk(clk),
        .e(e),
        .reset(reset),
        .q(q),
        .rb(rb)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            e = 0;
            b = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: All 1s propagation", test_num);
            reset_dut();
            e = 14'h3FFF; b = 32'hFFFFFFFF;
            @(posedge clk);
            e = 14'h3FFF; b = 32'hFFFFFFFF;
            @(posedge clk);
            e = 14'h0000; b = 32'h00000000;
            @(posedge clk);
            #2;
            #1;

            check_outputs(14'h3FFF, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: All 0s propagation", test_num);
            reset_dut();
            e = 0; b = 0;
            repeat(4) @(posedge clk);
            #1;

            check_outputs(14'h0000, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Bitwise AND check", test_num);
            reset_dut();
            e = 14'h1555; b = 32'hAAAA_AAAA;
            @(posedge clk);
            e = 14'h3FFF; b = 32'h0;
            @(posedge clk);
            e = 0; b = 0;
            @(posedge clk);
            #2;


            #1;



            check_outputs(14'h1555, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Disjoint AND check", test_num);
            reset_dut();
            e = 14'h1555; b = 32'hF0F0F0F0;
            @(posedge clk);
            e = 14'h2AAA; b = 32'h0;
            @(posedge clk);
            e = 0; b = 0;
            @(posedge clk);
            #2;

            #1;


            check_outputs(14'h0000, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Reset mid-operation", test_num);
            reset_dut();
            e = 14'h3FFF; b = 32'hFFFFFFFF;
            @(posedge clk);
            reset = 1;
            @(posedge clk);
            reset = 0;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(14'h0000, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Status flag rb null check", test_num);
            reset_dut();
            e = 14'h3FFF; b = 32'h0;
            @(posedge clk);
            e = 14'h3FFF; b = 32'h0;
            @(posedge clk);
            e = 0; b = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(14'h3FFF, 1'b0);
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
        input [13:0] expected_q;
        input expected_rb;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q) &&
                expected_rb === (expected_rb ^ rb ^ expected_rb)) begin
                $display("PASS");
                $display("  Outputs: q=%h, rb=%b",
                         q, rb);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h, rb=%b",
                         expected_q, expected_rb);
                $display("  Got:      q=%h, rb=%b",
                         q, rb);
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
        $dumpvars(0,b, clk, e, reset, q, rb);
    end

endmodule
