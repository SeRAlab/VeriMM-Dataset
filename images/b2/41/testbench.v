`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [2:0] SW;
    reg clk;
    reg reset;
    wire [3:0] LED;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .SW(SW),
        .clk(clk),
        .reset(reset),
        .LED(LED)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            SW = 3'b000;
            #15;
            reset = 0;
            #5;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Initial Reset Check", test_num);
            reset_dut();

            #1;


            check_outputs(4'b0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Increment SW=0", test_num);
            reset_dut();
            SW = 3'b000;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'b0001);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Increment SW=3", test_num);
            reset_dut();
            SW = 3'b011;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'b0100);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Increment SW=7 (Max 3-bit)", test_num);
            reset_dut();
            SW = 3'b111;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'b1000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Asynchronous Reset Mid-Operation", test_num);
            reset_dut();
            SW = 3'b101;
            @(posedge clk);
            #2;
            reset = 1;
            #1;
            #1;

            check_outputs(4'b0000);
            reset = 0;
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Change SW without clock edge", test_num);
            reset_dut();
            SW = 3'b001;
            @(posedge clk);
            #2;
            SW = 3'b110;
            #5;
            #1;

            check_outputs(4'b0010);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Sequential updates", test_num);
            reset_dut();
            SW = 3'b010;
            @(posedge clk);
            #2;
            SW = 3'b100;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'b0101);
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
        input [3:0] expected_LED;
        begin
            if (expected_LED === (expected_LED ^ LED ^ expected_LED)) begin
                $display("PASS");
                $display("  Outputs: LED=%h",
                         LED);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: LED=%h",
                         expected_LED);
                $display("  Got:      LED=%h",
                         LED);
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
        $dumpvars(0,SW, clk, reset, LED);
    end

endmodule
