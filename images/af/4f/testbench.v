`timescale 1ns/1ps

module gray_code_counter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg en;
    reg rst;
    wire [8:0] gray_count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    gray_code_counter dut (
        .clk(clk),
        .en(en),
        .rst(rst),
        .gray_count(gray_count)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(posedge clk);
            rst <= 1;
            en <= 0;
            @(posedge clk);
            #1 rst <= 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Reset check", test_num);
            reset_dut();

            #1;


            check_outputs(9'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Single increment", test_num);
            reset_dut();
            en <= 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(9'd1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Two increments", test_num);
            reset_dut();
            en <= 1;
            repeat(2) @(posedge clk);
            #1;

            #1;


            check_outputs(9'd3);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Seven increments", test_num);
            reset_dut();
            en <= 1;
            repeat(7) @(posedge clk);
            #1;

            #1;


            check_outputs(9'd4);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Ten increments", test_num);
            reset_dut();
            en <= 1;
            repeat(10) @(posedge clk);
            #1;

            #1;


            check_outputs(9'd15);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Enable signal toggle", test_num);
            reset_dut();
            en <= 1;
            repeat(5) @(posedge clk);
            en <= 0;
            repeat(5) @(posedge clk);
            en <= 1;
            repeat(5) @(posedge clk);
            #1;

            #1;


            check_outputs(9'd15);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %03d: 9-bit Rollover check", test_num);
            reset_dut();
            en <= 1;
            repeat(512) @(posedge clk);
            #1;

            #1;


            check_outputs(9'd0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %03d: High bit transition (255)", test_num);
            reset_dut();
            en <= 1;
            repeat(255) @(posedge clk);
            #1;

            #1;


            check_outputs(9'd128);
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
        input [8:0] expected_gray_count;
        begin
            if (expected_gray_count === (expected_gray_count ^ gray_count ^ expected_gray_count)) begin
                $display("PASS");
                $display("  Outputs: gray_count=%h",
                         gray_count);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: gray_count=%h",
                         expected_gray_count);
                $display("  Got:      gray_count=%h",
                         gray_count);
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
        $dumpvars(0,clk, en, rst, gray_count);
    end

endmodule
