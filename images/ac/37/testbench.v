`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg D_in;
    reg clk_in;
    reg rst;
    wire D_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .D_in(D_in),
        .clk_in(clk_in),
        .rst(rst),
        .D_out(D_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk_in = 0;
        forever #5 clk_in = ~clk_in;
    end

        task reset_dut;

        begin
            rst = 1;
            D_in = 0;
            @(posedge clk_in);
            #1 rst = 0;
            @(posedge clk_in);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Success pulse generation (SR full + transition)", test_num);
            reset_dut();


            D_in = 1;
            repeat (12) @(posedge clk_in);


            D_in = 0;
            @(posedge clk_in);


            D_in = 1;
            @(posedge clk_in);


            #1 #1;
 check_outputs(1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: No pulse (SR partially full)", test_num);
            reset_dut();


            D_in = 1;
            repeat (5) @(posedge clk_in);

            D_in = 0;
            @(posedge clk_in);

            D_in = 1;
            @(posedge clk_in);

            #1 #1;
 check_outputs(0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: No pulse (SR full but no 0->1 transition)", test_num);
            reset_dut();


            D_in = 1;
            repeat (15) @(posedge clk_in);


            D_in = 1;
            @(posedge clk_in);

            #1 #1;
 check_outputs(0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset clears shift register state", test_num);
            reset_dut();

            D_in = 1;
            repeat (12) @(posedge clk_in);


            rst = 1;
            @(posedge clk_in);
            rst = 0;


            D_in = 0;
            @(posedge clk_in);
            D_in = 1;
            @(posedge clk_in);

            #1 #1;
 check_outputs(0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verify pulse is single cycle", test_num);
            reset_dut();


            D_in = 1;
            repeat (12) @(posedge clk_in);
            D_in = 0;
            @(posedge clk_in);
            D_in = 1;
            @(posedge clk_in);


            @(posedge clk_in);


            #1 #1;
 check_outputs(0);
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
        input expected_D_out;
        begin
            if (expected_D_out === (expected_D_out ^ D_out ^ expected_D_out)) begin
                $display("PASS");
                $display("  Outputs: D_out=%b",
                         D_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: D_out=%b",
                         expected_D_out);
                $display("  Got:      D_out=%b",
                         D_out);
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
        $dumpvars(0,D_in, clk_in, rst, D_out);
    end

endmodule
