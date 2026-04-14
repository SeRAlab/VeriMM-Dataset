`timescale 1ns/1ps

module d_ff_async_set_reset_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg d;
    reg rst;
    reg set;
    wire q;
    wire q_bar;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    d_ff_async_set_reset dut (
        .clk(clk),
        .d(d),
        .rst(rst),
        .set(set),
        .q(q),
        .q_bar(q_bar)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            set = 0;
            d = 0;
            #15;
            rst = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase 001: Asynchronous Reset");
            d = 1;
            #5;
            rst = 1;
            #2;
            #1;

            check_outputs(1'b0, 1'b1);
            rst = 0;
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase 002: Asynchronous Set");
            d = 0;
            #5;
            set = 1;
            #2;
            #1;

            check_outputs(1'b1, 1'b0);
            set = 0;
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase 003: Synchronous D=1");
            d = 1;
            rst = 0;
            set = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase 004: Synchronous D=0");

            d = 1;
            @(posedge clk);
            #2;

            d = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase 005: Async Reset overriding D at clock edge");
            d = 1;
            rst = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0, 1'b1);
            rst = 0;
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("Testcase 006: Async Set overriding D at clock edge");
            d = 0;
            set = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1, 1'b0);
            set = 0;
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;
            $display("Testcase 007: Stability between clock edges");
            d = 1;
            @(posedge clk);
            #2;
            d = 0;
            #3;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("d_ff_async_set_reset Testbench");
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
        input expected_q;
        input expected_q_bar;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q) &&
                expected_q_bar === (expected_q_bar ^ q_bar ^ expected_q_bar)) begin
                $display("PASS");
                $display("  Outputs: q=%b, q_bar=%b",
                         q, q_bar);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%b, q_bar=%b",
                         expected_q, expected_q_bar);
                $display("  Got:      q=%b, q_bar=%b",
                         q, q_bar);
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
        $dumpvars(0,clk, d, rst, set, q, q_bar);
    end

endmodule
