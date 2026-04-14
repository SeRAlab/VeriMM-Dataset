`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] key_in;
    wire [3:0] key;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .key_in(key_in),
        .key(key)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            key_in = 4'b0000;


            repeat (5) @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros", test_num);
            reset_dut();
            key_in = 4'b0000;
            repeat(3) @(posedge clk);
            #1 #1;
 check_outputs(4'b0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Single Cycle Pulse", test_num);
            reset_dut();
            @(negedge clk) key_in = 4'b0001;
            @(negedge clk) key_in = 4'b0000;
            @(negedge clk) key_in = 4'b0000;
            @(posedge clk);
            #1 #1;
 check_outputs(4'b0001);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Sequential Bit Filling", test_num);
            reset_dut();
            @(negedge clk) key_in = 4'b0001;
            @(negedge clk) key_in = 4'b0010;
            @(negedge clk) key_in = 4'b0100;
            @(posedge clk);
            #1 #1;
 check_outputs(4'b0111);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Sustained Input", test_num);
            reset_dut();
            @(negedge clk) key_in = 4'b1010;
            repeat(4) @(negedge clk);
            @(posedge clk);
            #1 #1;
 check_outputs(4'b1010);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Rapid Bouncing", test_num);
            reset_dut();
            @(negedge clk) key_in = 4'b1111;
            @(negedge clk) key_in = 4'b0000;
            @(negedge clk) key_in = 4'b1111;
            @(posedge clk);
            #1 #1;
 check_outputs(4'b1111);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Return to Zero", test_num);
            reset_dut();

            @(negedge clk) key_in = 4'b1111;
            repeat(2) @(negedge clk);

            key_in = 4'b0000;
            repeat(3) @(negedge clk);
            @(posedge clk);
            #1 #1;
 check_outputs(4'b0000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating Pattern", test_num);
            reset_dut();
            @(negedge clk) key_in = 4'b1010;
            @(negedge clk) key_in = 4'b0101;
            @(negedge clk) key_in = 4'b1010;
            @(posedge clk);
            #1 #1;
 check_outputs(4'b1111);
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
        input [3:0] expected_key;
        begin
            if (expected_key === (expected_key ^ key ^ expected_key)) begin
                $display("PASS");
                $display("  Outputs: key=%h",
                         key);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: key=%h",
                         expected_key);
                $display("  Got:      key=%h",
                         key);
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
        $dumpvars(0,clk, key_in, key);
    end

endmodule
