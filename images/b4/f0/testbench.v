`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] in;
    wire [4:0] out;

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
            in = 4'b0000;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            in = 4'b0000;
            @(posedge clk);
            #1;
            $display("Test Case %0d: Input 0000 (0)", test_num);
            #1;

            check_outputs(5'b00000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            in = 4'b0111;
            @(posedge clk);
            #1;
            $display("Test Case %0d: Input 0111 (+7)", test_num);
            #1;

            check_outputs(5'b00111);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            in = 4'b0011;
            @(posedge clk);
            #1;
            $display("Test Case %0d: Input 0011 (+3)", test_num);
            #1;

            check_outputs(5'b00011);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            in = 4'b1111;
            @(posedge clk);
            #1;
            $display("Test Case %0d: Input 1111 (-1)", test_num);

            #1;


            check_outputs(5'b00001);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            in = 4'b1000;
            @(posedge clk);
            #1;
            $display("Test Case %0d: Input 1000 (-8)", test_num);

            #1;


            check_outputs(5'b01000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_dut();
            in = 4'b1100;
            @(posedge clk);
            #1;
            $display("Test Case %0d: Input 1100 (-4)", test_num);

            #1;


            check_outputs(5'b00100);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            reset_dut();
            in = 4'b1001;
            @(posedge clk);
            #1;
            $display("Test Case %0d: Input 1001 (-7)", test_num);

            #1;


            check_outputs(5'b00111);
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
        input [4:0] expected_out;
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
