`timescale 1ns/1ps

module shift_reg_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] d;
    reg load;
    reg rst;
    wire [7:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_reg dut (
        .clk(clk),
        .d(d),
        .load(load),
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
            rst = 1;
            d = 8'h00;
            load = 0;
            #15;
            rst = 0;
            #5;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case 001: Verification of Asynchronous Reset");
            reset_dut();

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case 002: Parallel Load 0xAA");
            reset_dut();
            @(negedge clk);
            d = 8'hAA;
            load = 1;
            @(negedge clk);
            load = 0;

            #1;


            check_outputs(8'hAA);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case 003: Parallel Load 0x55");
            reset_dut();
            @(negedge clk);
            d = 8'h55;
            load = 1;
            @(negedge clk);
            load = 0;

            #1;


            check_outputs(8'h55);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case 004: Shift Left (1 bit)");
            reset_dut();
            @(negedge clk);
            d = 8'h01;
            load = 1;
            @(negedge clk);
            load = 0;
            @(negedge clk);

            #1;


            check_outputs(8'h02);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case 005: Shift Left (4 bits)");
            reset_dut();
            @(negedge clk);
            d = 8'h0F;
            load = 1;
            @(negedge clk);
            load = 0;
            repeat(4) @(negedge clk);

            #1;


            check_outputs(8'hF0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case 006: Asynchronous Reset Mid-Cycle");
            reset_dut();
            @(negedge clk);
            d = 8'hFF;
            load = 1;
            @(negedge clk);
            load = 0;

            #2;
            rst = 1;
            #1;

            #1;


            check_outputs(8'h00);
            #5;
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
        $display("shift_reg Testbench");
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
        $dumpvars(0,clk, d, load, rst, q);
    end

endmodule
