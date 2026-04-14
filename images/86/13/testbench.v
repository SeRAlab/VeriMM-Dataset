`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] Datain;
    wire [15:0] Dataout;
    wire Empty;
    wire Full;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Datain(Datain),
        .Dataout(Dataout),
        .Empty(Empty),
        .Full(Full)
    );

        task reset_dut;

        begin
            rst = 1;
            push = 0;
            pop = 0;
            mode = 0;
            Datain = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task push_data;

        input [15:0] val;
        begin
            @(negedge clk);
            push = 1;
            Datain = val;
            @(posedge clk);
            #1 push = 0;
        end
        endtask

    task pop_data;

        begin
            @(negedge clk);
            pop = 1;
            @(posedge clk);
            #1 pop = 0;
        end
        endtask

    task testcase001;

        begin
            $display("Testcase 001: Initial Reset State");
            reset_dut();
            #1;

            check_outputs(16'h0000, 1, 0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Stack LIFO Operation");
            reset_dut();
            mode = 0;
            push_data(16'hAAAA);
            push_data(16'hBBBB);
            pop_data();
            #2;
            #1;

            check_outputs(16'hBBBB, 0, 0);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Queue FIFO Operation");
            reset_dut();
            mode = 1;
            push_data(16'h1111);
            push_data(16'h2222);
            pop_data();
            #2;
            #1;

            check_outputs(16'h1111, 0, 0);
        end
        endtask

    task testcase004;

        integer i;
        begin
            $display("Testcase 004: Fill Queue to Full");
            reset_dut();
            mode = 1;
            for(i=0; i<8; i=i+1) begin
                push_data(i);
            end
            #2;
            #1;

            check_outputs(16'h0000, 0, 1);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Stack Draining to Empty");
            reset_dut();
            mode = 0;
            push_data(16'h5555);
            pop_data();
            #2;
            #1;

            check_outputs(16'h5555, 1, 0);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Queue Interleaved Push/Pop");
            reset_dut();
            mode = 1;
            push_data(16'h1);
            push_data(16'h2);
            pop_data();
            push_data(16'h3);
            pop_data();
            #2;
            #1;

            check_outputs(16'h0002, 0, 0);
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
        input [15:0] expected_Dataout;
        input expected_Empty;
        input expected_Full;
        begin
            if (expected_Dataout === (expected_Dataout ^ Dataout ^ expected_Dataout) &&
                expected_Empty === (expected_Empty ^ Empty ^ expected_Empty) &&
                expected_Full === (expected_Full ^ Full ^ expected_Full)) begin
                $display("PASS");
                $display("  Outputs: Dataout=%h, Empty=%b, Full=%b",
                         Dataout, Empty, Full);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Dataout=%h, Empty=%b, Full=%b",
                         expected_Dataout, expected_Empty, expected_Full);
                $display("  Got:      Dataout=%h, Empty=%b, Full=%b",
                         Dataout, Empty, Full);
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
        $dumpvars(0,Datain, Dataout, Empty, Full);
    end

endmodule
