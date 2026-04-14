`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [254:0] in;
    wire [7:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in(in),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            in = 255'b0;
            repeat (20) @(posedge clk);
        end
        endtask
    task run_test;

        input [254:0] test_in;
        input [7:0] expected_count;
        begin
            @(posedge clk);
            in = test_in;

            repeat (20) @(posedge clk);
            #1;

            check_outputs(expected_count);
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: All Zeros", test_num);
            reset_dut();
            run_test(255'b0, 8'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: All Ones", test_num);
            reset_dut();
            run_test({255{1'b1}}, 8'd255);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Single bit (LSB)", test_num);
            reset_dut();
            run_test(255'd1, 8'd1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Single bit (MSB)", test_num);
            reset_dut();
            run_test(255'b1 << 254, 8'd1);
        end
        endtask

    task testcase005;

        reg [254:0] pattern;
        begin
            test_num = 5;
            $display("Testcase %03d: Alternating Bits", test_num);
            reset_dut();
            pattern = {128{2'b01}};
            run_test(pattern, 8'd127);




            pattern = 0;
            for(i=0; i<255; i=i+2) pattern[i] = 1'b1;
            run_test(pattern, 8'd128);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Sparse Bits", test_num);
            reset_dut();

            run_test(255'hA000_0000_0000_0000_F000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_000F, 8'd12);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %03d: First 10 bits", test_num);
            reset_dut();
            run_test(255'b1111111111, 8'd10);
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
        $dumpvars(0,clk, in, out);
    end

endmodule
