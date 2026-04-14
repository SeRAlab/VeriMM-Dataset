`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg EchoPulse;
    reg clk;
    wire [15:0] D;
    wire [9:0] T;
    wire Trigger;
    wire [3:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .EchoPulse(EchoPulse),
        .clk(clk),
        .D(D),
        .T(T),
        .Trigger(Trigger),
        .count(count)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            EchoPulse = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Testing EchoPulse accumulation into D", test_num);
            reset_dut();


            EchoPulse = 1;
            repeat(5) @(posedge clk);


            EchoPulse = 0;
            @(posedge clk);
            #1;





            #1;






            check_outputs(16'd5, 10'd994, 1'b1, 4'd4);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Testing countdown and Trigger assertion", test_num);
            reset_dut();

            EchoPulse = 0;

            repeat(2) @(posedge clk);
            #1;





            #1;






            check_outputs(16'd0, 10'd997, 1'b1, 4'd7);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Testing long EchoPulse duration", test_num);
            reset_dut();

            EchoPulse = 1;
            repeat(8) @(posedge clk);
            EchoPulse = 0;
            @(posedge clk);
            #1;





            #1;






            check_outputs(16'd8, 10'd990, 1'b0, 4'd0);
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
        input [15:0] expected_D;
        input [9:0] expected_T;
        input expected_Trigger;
        input [3:0] expected_count;
        begin
            if (expected_D === (expected_D ^ D ^ expected_D) &&
                expected_T === (expected_T ^ T ^ expected_T) &&
                expected_Trigger === (expected_Trigger ^ Trigger ^ expected_Trigger) &&
                expected_count === (expected_count ^ count ^ expected_count)) begin
                $display("PASS");
                $display("  Outputs: D=%h, T=%h, Trigger=%b, count=%h",
                         D, T, Trigger, count);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: D=%h, T=%h, Trigger=%b, count=%h",
                         expected_D, expected_T, expected_Trigger, expected_count);
                $display("  Got:      D=%h, T=%h, Trigger=%b, count=%h",
                         D, T, Trigger, count);
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
        $dumpvars(0,EchoPulse, clk, D, T, Trigger, count);
    end

endmodule
