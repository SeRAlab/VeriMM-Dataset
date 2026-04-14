`timescale 1ns/1ps

module shift_register_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg load_n;
    reg [7:0] parallel_in;
    reg rst_n;
    wire [7:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_register dut (
        .clk(clk),
        .load_n(load_n),
        .parallel_in(parallel_in),
        .rst_n(rst_n),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            load_n = 1;
            parallel_in = 8'h00;
            @(posedge clk);
            #1 rst_n = 1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Reset Check", test_num);
            reset_dut();

            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Parallel Load 8'hA5", test_num);
            reset_dut();
            @(negedge clk);
            load_n = 0;
            parallel_in = 8'hA5;
            @(posedge clk);
            #1;
            load_n = 1;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Single Left Shift (01 -> 02)", test_num);
            reset_dut();

            @(negedge clk);
            load_n = 0;
            parallel_in = 8'h01;
            @(posedge clk);
            #1;
            load_n = 1;

            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h02);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Multiple Shifts (0F -> F0)", test_num);
            reset_dut();

            @(negedge clk);
            load_n = 0;
            parallel_in = 8'h0F;
            @(posedge clk);
            #1;
            load_n = 1;

            repeat(4) @(posedge clk);
            #1;
            #1;

            check_outputs(8'hF0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Shift out MSB (80 -> 00)", test_num);
            reset_dut();

            @(negedge clk);
            load_n = 0;
            parallel_in = 8'h80;
            @(posedge clk);
            #1;
            load_n = 1;

            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %0d: Shift 8 times (FF -> 00)", test_num);
            reset_dut();

            @(negedge clk);
            load_n = 0;
            parallel_in = 8'hFF;
            @(posedge clk);
            #1;
            load_n = 1;

            repeat(8) @(posedge clk);
            #1;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("\nTestcase %0d: Load Priority Check", test_num);
            reset_dut();

            @(negedge clk);
            load_n = 0;
            parallel_in = 8'hAA;
            @(posedge clk);
            @(negedge clk);
            parallel_in = 8'h55;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h55);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("shift_register Testbench");
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
        input [7:0] expected_q;
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
        $dumpvars(0,clk, load_n, parallel_in, rst_n, q);
    end

endmodule
