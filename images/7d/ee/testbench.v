`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] in;
    reg reset;
    wire [7:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in(in),
        .reset(reset),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            in = 8'h00;
            @(posedge clk);
            #1 reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: All MSBs set to 1", test_num);
            reset_dut();
            repeat(4) begin
                in = 8'h80;
                @(posedge clk);
            end
            #1 #1;
 check_outputs(8'h0F);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Alternating MSB pattern (1010)", test_num);
            reset_dut();
            in = 8'h80; @(posedge clk);
            in = 8'h00; @(posedge clk);
            in = 8'h85; @(posedge clk);
            in = 8'h7F; @(posedge clk);
            #1 #1;
 check_outputs(8'h0A);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Single MSB shifted to last register", test_num);
            reset_dut();
            in = 8'hFF; @(posedge clk);
            in = 8'h01; @(posedge clk);
            in = 8'h02; @(posedge clk);
            in = 8'h03; @(posedge clk);
            #1 #1;
 check_outputs(8'h08);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: All MSBs zero with non-zero LSBs", test_num);
            reset_dut();
            repeat(4) begin
                in = 8'h7F;
                @(posedge clk);
            end
            #1 #1;
 check_outputs(8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Reset functionality check", test_num);
            reset_dut();
            in = 8'h80; @(posedge clk);
            in = 8'h80; @(posedge clk);
            reset_dut();
            #1 #1;
 check_outputs(8'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Continuous stream shifting", test_num);
            reset_dut();

            in = 8'h80; @(posedge clk);
            in = 8'h80; @(posedge clk);
            in = 8'h80; @(posedge clk);
            in = 8'h80; @(posedge clk);
            in = 8'h00; @(posedge clk);
            in = 8'h80; @(posedge clk);
            in = 8'h00; @(posedge clk);
            in = 8'h80; @(posedge clk);
            #1 #1;
 check_outputs(8'h05);
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
        input [7:0] expected_out;
        begin
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
        $dumpvars(0,clk, in, reset, out);
    end

endmodule
