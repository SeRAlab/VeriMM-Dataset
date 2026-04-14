`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [2:0] in_vec;
    wire o0;
    wire o1;
    wire o2;
    wire [2:0] out_vec;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in_vec(in_vec),
        .o0(o0),
        .o1(o1),
        .o2(o2),
        .out_vec(out_vec)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            in_vec = 3'b000;
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Test %0d: All bits high (3'b111) propagation", test_num);
            in_vec = 3'b111;
            @(posedge clk);
            @(posedge clk);
            #1;

            #1;


            check_outputs(1, 1, 1, 3'b111);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Test %0d: Pipelined sequence (101 followed by 010)", test_num);
            in_vec = 3'b101;
            @(posedge clk);
            in_vec = 3'b010;
            @(posedge clk);
            #1;


            #1;



            check_outputs(0, 1, 0, 3'b101);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Test %0d: Bit 0 only (3'b001) propagation", test_num);
            in_vec = 3'b001;
            @(posedge clk);
            @(posedge clk);
            #1;

            #1;


            check_outputs(1, 0, 0, 3'b001);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Test %0d: Bit 1 only (3'b010) propagation", test_num);
            in_vec = 3'b010;
            @(posedge clk);
            @(posedge clk);
            #1;

            #1;


            check_outputs(0, 1, 0, 3'b010);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Test %0d: Bit 2 only (3'b100) propagation", test_num);
            in_vec = 3'b100;
            @(posedge clk);
            @(posedge clk);
            #1;

            #1;


            check_outputs(0, 0, 1, 3'b100);
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
        input expected_o0;
        input expected_o1;
        input expected_o2;
        input [2:0] expected_out_vec;
        begin
            if (expected_o0 === (expected_o0 ^ o0 ^ expected_o0) &&
                expected_o1 === (expected_o1 ^ o1 ^ expected_o1) &&
                expected_o2 === (expected_o2 ^ o2 ^ expected_o2) &&
                expected_out_vec === (expected_out_vec ^ out_vec ^ expected_out_vec)) begin
                $display("PASS");
                $display("  Outputs: o0=%b, o1=%b, o2=%b, out_vec=%h",
                         o0, o1, o2, out_vec);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o0=%b, o1=%b, o2=%b, out_vec=%h",
                         expected_o0, expected_o1, expected_o2, expected_out_vec);
                $display("  Got:      o0=%b, o1=%b, o2=%b, out_vec=%h",
                         o0, o1, o2, out_vec);
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
        $dumpvars(0,clk, in_vec, o0, o1, o2, out_vec);
    end

endmodule
