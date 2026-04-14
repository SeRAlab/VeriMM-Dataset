`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [89:0] in;
    wire [44:0] line0;
    wire [44:0] line1;
    wire [89:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in(in),
        .line0(line0),
        .line1(line1),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            in = 90'b0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: All Zeros", test_num);
            in = 90'h0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(45'h0, 45'h0, 90'h0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: All Ones", test_num);
            in = {90{1'b1}};
            @(posedge clk);
            #2;
            #1;

            check_outputs({45{1'b1}}, {45{1'b1}}, {90{1'b1}});
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Alternating Pattern 1010...", test_num);
            in = 90'h2AAAAAAAAAAAAAAAAAAAAAA;
            @(posedge clk);
            #2;
            #1;

            check_outputs(in[44:0], in[89:45], in);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Data Segmenting Check", test_num);

            in = {45'h15555555555, 45'h0AAAAAAAAAA};
            @(posedge clk);
            #2;
            #1;

            check_outputs(45'h0AAAAAAAAAA, 45'h15555555555, {45'h15555555555, 45'h0AAAAAAAAAA});
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Boundary Bits Check", test_num);

            in = 90'b0;
            in[0]  = 1'b1;
            in[44] = 1'b1;
            in[45] = 1'b1;
            in[89] = 1'b1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(in[44:0], in[89:45], in);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Middle Bit Shift Check", test_num);
            in = 90'h00000000000100000000000;
            @(posedge clk);
            #2;
            #1;

            check_outputs(45'h10000000000, 45'h0, in);


            in = 90'h00000000000200000000000;
            @(posedge clk);
            #2;
            #1;

            check_outputs(45'h0, 45'h1, in);
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
        input [44:0] expected_line0;
        input [44:0] expected_line1;
        input [89:0] expected_out;
        begin
            if (expected_line0 === (expected_line0 ^ line0 ^ expected_line0) &&
                expected_line1 === (expected_line1 ^ line1 ^ expected_line1) &&
                expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: line0=%h, line1=%h, out=%h",
                         line0, line1, out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: line0=%h, line1=%h, out=%h",
                         expected_line0, expected_line1, expected_out);
                $display("  Got:      line0=%h, line1=%h, out=%h",
                         line0, line1, out);
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
        $dumpvars(0,clk, in, line0, line1, out);
    end

endmodule
