`timescale 1ns/1ps

module counter4bit_ud_tc_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg up_down;
    wire [3:0] q;
    wire tc;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    counter4bit_ud_tc dut (
        .clk(clk),
        .rst(rst),
        .up_down(up_down),
        .q(q),
        .tc(tc)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            up_down = 1;
            @(posedge clk);
            #1 rst = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Checking reset state and Up mode TC", test_num);
            reset_dut();
            up_down = 1;
            #1;
            #1;

            check_outputs(4'd0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Count Up to 15", test_num);
            reset_dut();
            up_down = 1;
            repeat(15) @(posedge clk);
            #1;
            #1;

            check_outputs(4'd15, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Count Up 16 times (Wrap to 0)", test_num);
            reset_dut();
            up_down = 1;
            repeat(16) @(posedge clk);
            #1;
            #1;

            check_outputs(4'd0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Reset and Down mode TC at 0", test_num);
            reset_dut();
            up_down = 0;
            #1;
            #1;

            check_outputs(4'd0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Count Down from 0 to 15", test_num);
            reset_dut();
            up_down = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd15, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Count Up to 1 then Down to 0", test_num);
            reset_dut();
            up_down = 1;
            @(posedge clk);
            up_down = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd0, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Switch direction at Max value", test_num);
            reset_dut();
            up_down = 1;
            repeat(15) @(posedge clk);
            up_down = 0;
            #1;
            #1;

            check_outputs(4'd15, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Count Up 5, Down 2", test_num);
            reset_dut();
            up_down = 1;
            repeat(5) @(posedge clk);
            up_down = 0;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(4'd3, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("counter4bit_ud_tc Testbench");
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
        input [3:0] expected_q;
        input expected_tc;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q) &&
                expected_tc === (expected_tc ^ tc ^ expected_tc)) begin
                $display("PASS");
                $display("  Outputs: q=%h, tc=%b",
                         q, tc);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h, tc=%b",
                         expected_q, expected_tc);
                $display("  Got:      q=%h, tc=%b",
                         q, tc);
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
        $dumpvars(0,clk, rst, up_down, q, tc);
    end

endmodule
