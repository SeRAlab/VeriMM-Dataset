`timescale 1ns/1ps

module counter5bit_inc3_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg en;
    reg rst;
    wire [4:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    counter5bit_inc3 dut (
        .clk(clk),
        .en(en),
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
            en = 0;
            @(negedge clk);
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %03d: Reset verification", test_num);
            reset_dut();

            #1;


            check_outputs(5'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %03d: Single increment (0 -> 3)", test_num);
            reset_dut();
            @(negedge clk);
            en = 1;
            @(negedge clk);
            en = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(5'd3);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %03d: Multiple increments (5 steps: 0 -> 15)", test_num);
            reset_dut();
            @(negedge clk);
            en = 1;
            repeat (5) @(negedge clk);
            en = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(5'd15);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %03d: Enable signal hold check", test_num);
            reset_dut();
            @(negedge clk);
            en = 1;
            repeat (2) @(negedge clk);
            en = 0;
            repeat (3) @(negedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(5'd6);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %03d: Overflow wrap-around (11 steps: 33 mod 32 = 1)", test_num);
            reset_dut();
            @(negedge clk);
            en = 1;
            repeat (11) @(negedge clk);
            en = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(5'd1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %03d: Intermittent enable check", test_num);
            reset_dut();
            @(negedge clk);
            en = 1; @(negedge clk);
            en = 0; @(negedge clk);
            en = 1; @(negedge clk);
            en = 0; @(negedge clk);
            en = 1; @(negedge clk);
            en = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(5'd9);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("\nTestcase %03d: Full 32-cycle rotation (96 mod 32 = 0)", test_num);
            reset_dut();
            @(negedge clk);
            en = 1;
            repeat (32) @(negedge clk);
            en = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(5'd0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("counter5bit_inc3 Testbench");
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
        input [4:0] expected_q;
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
        $dumpvars(0,clk, en, rst, q);
    end

endmodule
