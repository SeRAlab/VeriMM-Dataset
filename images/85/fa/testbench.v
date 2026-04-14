`timescale 1ns/1ps

module gray_code_counter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg en;
    reg rst;
    wire [15:0] gray;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    gray_code_counter dut (
        .clk(clk),
        .en(en),
        .rst(rst),
        .gray(gray)
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
        en = 0;
        @(negedge clk);
        rst = 0;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        reset_dut();

        #1;


        check_outputs(16'h0000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        reset_dut();
        @(negedge clk);
        en = 1;
        @(negedge clk);
        en = 0;

        #1;


        check_outputs(16'h0001);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        reset_dut();
        en = 1;

        repeat(3) @(negedge clk);
        en = 0;



        #1;




        check_outputs(16'h0002);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        reset_dut();
        en = 1;
        repeat(2) @(negedge clk);
        en = 0;
        repeat(3) @(negedge clk);
        en = 1;
        @(negedge clk);
        en = 0;
        #1;

        check_outputs(16'h0002);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        reset_dut();
        en = 1;
        repeat(10) @(negedge clk);
        en = 0;

        #1;


        check_outputs(16'h000F);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        reset_dut();
        en = 1;
        repeat(5) @(negedge clk);
        rst = 1;
        @(negedge clk);
        rst = 0;
        en = 0;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("gray_code_counter Testbench");
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
        input [15:0] expected_gray;
        begin
            if (expected_gray === (expected_gray ^ gray ^ expected_gray)) begin
                $display("PASS");
                $display("  Outputs: gray=%h",
                         gray);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: gray=%h",
                         expected_gray);
                $display("  Got:      gray=%h",
                         gray);
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
        $dumpvars(0,clk, en, rst, gray);
    end

endmodule
