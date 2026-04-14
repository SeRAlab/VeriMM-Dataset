`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [1:0] a;
    reg clk;
    wire [1:0] yout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .clk(clk),
        .yout(yout)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            a = 2'b00;

            @(negedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Load 2'b01 into register", test_num);
            reset_dut();
            a = 2'b01;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Load 2'b10 into register", test_num);
            reset_dut();
            a = 2'b10;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Load 2'b11 into register", test_num);
            reset_dut();
            a = 2'b11;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'b11);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Verify register holds value across multiple cycles", test_num);
            reset_dut();
            a = 2'b11;
            @(posedge clk);
            #1;
            a = 2'b00;
            repeat (2) @(posedge clk);
            #1;

            #1;


            check_outputs(2'b00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Rapid input changes between edges", test_num);
            reset_dut();
            a = 2'b10;
            @(posedge clk);
            #2 a = 2'b01;
            #2 a = 2'b11;

            @(posedge clk);
            #1;
            #1;

            check_outputs(2'b11);
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
        input [1:0] expected_yout;
        begin
            if (expected_yout === (expected_yout ^ yout ^ expected_yout)) begin
                $display("PASS");
                $display("  Outputs: yout=%h",
                         yout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: yout=%h",
                         expected_yout);
                $display("  Got:      yout=%h",
                         yout);
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
        $dumpvars(0,a, clk, yout);
    end

endmodule
