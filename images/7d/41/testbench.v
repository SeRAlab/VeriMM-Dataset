`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg EN;
    reg [3:0] IN;
    reg [1:0] SEL;
    reg clk;
    wire out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .EN(EN),
        .IN(IN),
        .SEL(SEL),
        .clk(clk),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            EN = 0;
            IN = 4'b0000;
            SEL = 2'b00;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase %0d: Select IN[0] = 1, EN = 1", test_num);
            IN = 4'b0001;
            SEL = 2'b00;
            EN = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase %0d: Select IN[1] = 0, EN = 1", test_num);
            IN = 4'b1101;
            SEL = 2'b01;
            EN = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase %0d: Select IN[2] = 1, EN = 1", test_num);
            IN = 4'b0100;
            SEL = 2'b10;
            EN = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase %0d: Select IN[3] = 0, EN = 1", test_num);
            IN = 4'b0111;
            SEL = 2'b11;
            EN = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase %0d: SEL=0, EN=0 (Expect High-Z)", test_num);
            IN = 4'b1111;
            SEL = 2'b00;
            EN = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'bz);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("Testcase %0d: SEL=3, EN=0 (Expect High-Z)", test_num);
            IN = 4'b1111;
            SEL = 2'b11;
            EN = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'bz);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;
            $display("Testcase %0d: Transition EN 1 -> 0", test_num);


            IN = 4'b1010;
            SEL = 2'b01;
            EN = 1;
            @(posedge clk);
            #1;


            EN = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'bz);
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
        begin
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%b",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%b",
                         expected_out);
                $display("  Got:      out=%b",
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
        $dumpvars(0,EN, IN, SEL, clk, out);
    end

endmodule
