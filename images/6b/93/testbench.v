`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg d;
    reg [3:0] in;
    wire out;
    wire [1:0] pos;
    wire [2:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .d(d),
        .in(in),
        .out(out),
        .pos(pos),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            in = 4'b0000;
            d = 0;
            repeat (4) @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Encoder bit 3, shift 1", test_num);
            in = 4'b1000;
            d = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0, 2'b11, 3'b001);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Encoder bit 2, shift 0", test_num);
            in = 4'b0100;
            d = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1, 2'b10, 3'b000);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Encoder bit 1, shift 1", test_num);
            in = 4'b0010;
            d = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1, 2'b01, 3'b001);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Encoder bit 0, shift 0", test_num);
            in = 4'b0001;
            d = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0, 2'b00, 3'b000);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Multi-bit Encoder Priority", test_num);
            in = 4'b1011;
            d = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0, 2'b11, 3'b001);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Shift Register Sequence", test_num);
            in = 4'b1000;

            d = 1; @(posedge clk); #1;
            d = 0; @(posedge clk); #1;
            d = 1; @(posedge clk); #2;



            #1;




            check_outputs(1'b0, 2'b11, 3'b101);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Shift Register Overflow and XOR", test_num);
            in = 4'b0010;

            d = 1; @(posedge clk); #1;
            d = 1; @(posedge clk); #1;
            d = 1; @(posedge clk); #1;
            d = 0; @(posedge clk); #2;


            #1;



            check_outputs(1'b0, 2'b01, 3'b110);
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
        input expected_out;
        input [1:0] expected_pos;
        input [2:0] expected_q;
        begin
            if (expected_out === (expected_out ^ out ^ expected_out) &&
                expected_pos === (expected_pos ^ pos ^ expected_pos) &&
                expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: out=%b, pos=%h, q=%h",
                         out, pos, q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%b, pos=%h, q=%h",
                         expected_out, expected_pos, expected_q);
                $display("  Got:      out=%b, pos=%h, q=%h",
                         out, pos, q);
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
        $dumpvars(0,clk, d, in, out, pos, q);
    end

endmodule
