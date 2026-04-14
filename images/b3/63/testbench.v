`timescale 1ns/1ps

module sync_down_counter_6bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    wire [5:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sync_down_counter_6bit dut (
        .clk(clk),
        .rst(rst),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(negedge clk);
            rst = 1;
            @(negedge clk);
            rst = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Checking Reset State...", test_num);
            reset_dut();

            #1;
            #1;

            check_outputs(6'h3F);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Checking down count 1 step...", test_num);
            reset_dut();
            @(posedge clk);
            #1;

            #1;


            check_outputs(6'h3E);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Checking down count 10 steps...", test_num);
            reset_dut();
            repeat(10) @(posedge clk);
            #1;

            #1;


            check_outputs(6'h35);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Checking count down to zero (63 steps)...", test_num);
            reset_dut();
            repeat(63) @(posedge clk);
            #1;

            #1;


            check_outputs(6'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Checking wrap-around from 0 to 63...", test_num);
            reset_dut();
            repeat(64) @(posedge clk);
            #1;

            #1;


            check_outputs(6'h3F);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Checking 100 steps of counting...", test_num);
            reset_dut();
            repeat(100) @(posedge clk);
            #1;


            #1;



            check_outputs(6'h1B);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Checking reset triggered mid-count...", test_num);
            reset_dut();
            repeat(20) @(posedge clk);
            @(negedge clk);
            rst = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(6'h3F);
            @(negedge clk);
            rst = 0;
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sync_down_counter_6bit Testbench");
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
        input [5:0] expected_q;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%h",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h",
                         expected_q);
                $display("  Got:      q=%h",
                         q);
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
        $dumpvars(0,clk, rst, q);
    end

endmodule
