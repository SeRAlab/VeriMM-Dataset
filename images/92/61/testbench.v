`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg reset;
    wire carry;
    wire [3:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .enable(enable),
        .reset(reset),
        .carry(carry),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(posedge clk);
            reset <= 1;
            enable <= 0;
            @(posedge clk);
            reset <= 0;
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset State", test_num);
            reset_dut();

            #1;


            check_outputs(1'b0, 4'b0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Single Increment", test_num);
            reset_dut();
            @(posedge clk);
            enable <= 1;
            @(posedge clk);
            enable <= 0;
            #1;
            #1;

            check_outputs(1'b0, 4'b0001);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Count to 5", test_num);
            reset_dut();
            enable <= 1;
            repeat (5) @(posedge clk);
            enable <= 0;
            #1;
            #1;

            check_outputs(1'b0, 4'b0101);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Enable/Disable behavior", test_num);
            reset_dut();
            enable <= 1;
            repeat (3) @(posedge clk);
            enable <= 0;
            repeat (3) @(posedge clk);
            enable <= 1;
            @(posedge clk);
            enable <= 0;
            #1;
            #1;

            check_outputs(1'b0, 4'b0100);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Terminal Count (15) and Carry", test_num);
            reset_dut();
            enable <= 1;
            repeat (15) @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 4'b1111);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Rollover to Zero", test_num);
            reset_dut();
            enable <= 1;
            repeat (16) @(posedge clk);
            enable <= 0;
            #1;

            #1;


            check_outputs(1'b0, 4'b0000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Carry behavior when disabled at max", test_num);
            reset_dut();
            enable <= 1;
            repeat (15) @(posedge clk);
            enable <= 0;
            @(posedge clk);
            #1;


            #1;



            check_outputs(1'b0, 4'b1111);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Synchronous Reset mid-count", test_num);
            reset_dut();
            enable <= 1;
            repeat (8) @(posedge clk);
            reset <= 1;
            @(posedge clk);
            reset <= 0;
            enable <= 0;
            #1;
            #1;

            check_outputs(1'b0, 4'b0000);
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
        testcase008();
        
        
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
        input expected_carry;
        input [3:0] expected_q;
        begin
            if (expected_carry === (expected_carry ^ carry ^ expected_carry) &&
                expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: carry=%b, q=%h",
                         carry, q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: carry=%b, q=%h",
                         expected_carry, expected_q);
                $display("  Got:      carry=%b, q=%h",
                         carry, q);
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
        $dumpvars(0,clk, enable, reset, carry, q);
    end

endmodule
