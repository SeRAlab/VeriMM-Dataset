`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    wire [2:0] count8;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .rst(rst),
        .count8(count8)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Reset", test_num);
            reset_dut();




            #1;





            check_outputs(3'b001);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Increment to 4", test_num);
            reset_dut();
            repeat(3) @(posedge clk);
            #1 #1;
 check_outputs(3'd4);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Increment to Max (7)", test_num);
            reset_dut();
            repeat(6) @(posedge clk);
            #1 #1;
 check_outputs(3'd7);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Wrap-around (7 to 0)", test_num);
            reset_dut();
            repeat(7) @(posedge clk);
            #1 #1;
 check_outputs(3'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Wrap-around and continue to 2", test_num);
            reset_dut();
            repeat(9) @(posedge clk);
            #1 #1;
 check_outputs(3'd2);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset during operation", test_num);
            reset_dut();
            repeat(4) @(posedge clk);
            rst = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(3'd0);
            rst = 0;
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Full 8-cycle sequence", test_num);
            reset_dut();
            repeat(8) @(posedge clk);
            #1 #1;
 check_outputs(3'd1);
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
        input [2:0] expected_count8;
        begin
            if (expected_count8 === (expected_count8 ^ count8 ^ expected_count8)) begin
                $display("PASS");
                $display("  Outputs: count8=%h",
                         count8);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count8=%h",
                         expected_count8);
                $display("  Got:      count8=%h",
                         count8);
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
        $dumpvars(0,clk, rst, count8);
    end

endmodule
