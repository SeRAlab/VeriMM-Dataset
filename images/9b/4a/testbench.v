`timescale 1ns/1ps

module up_down_counter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg en;
    reg reset;
    reg up;
    wire [2:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    up_down_counter dut (
        .clk(clk),
        .en(en),
        .reset(reset),
        .up(up),
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
            reset = 1;
            en = 0;
            up = 0;
            @(negedge clk);
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Basic Up Count", test_num);
            reset_dut();
            @(negedge clk);
            en = 1;
            up = 1;
            repeat(3) @(negedge clk);
            #1;

            check_outputs(3'd3);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Up Count Wrap Around (7 to 0)", test_num);
            reset_dut();
            @(negedge clk);
            en = 1;
            up = 1;
            repeat(8) @(negedge clk);
            #1;

            check_outputs(3'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Basic Down Count (0 to 7)", test_num);
            reset_dut();
            @(negedge clk);
            en = 1;
            up = 0;
            repeat(1) @(negedge clk);
            #1;

            check_outputs(3'd7);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Enable Signal Check", test_num);
            reset_dut();
            @(negedge clk);
            en = 1;
            up = 1;
            repeat(2) @(negedge clk);
            en = 0;
            repeat(3) @(negedge clk);
            #1;

            check_outputs(3'd2);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Direction Change (Up then Down)", test_num);
            reset_dut();
            @(negedge clk);
            en = 1;
            up = 1;
            repeat(5) @(negedge clk);
            up = 0;
            repeat(2) @(negedge clk);
            #1;

            check_outputs(3'd3);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Synchronous Reset Priority", test_num);
            reset_dut();
            @(negedge clk);
            en = 1;
            up = 1;
            repeat(4) @(negedge clk);
            reset = 1;
            @(negedge clk);
            #1;

            check_outputs(3'd0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("up_down_counter Testbench");
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
        input [2:0] expected_q;
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
        $dumpvars(0,clk, en, reset, up, q);
    end

endmodule
