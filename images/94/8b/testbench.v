`timescale 1ns/1ps

module counter_6bit_down_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg en;
    reg rst;
    wire [5:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    counter_6bit_down dut (
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
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Synchronous Reset Check", test_num);
            reset_dut();

            #1;


            check_outputs(6'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Single Step Decrement (Wrap around 0 to 63)", test_num);
            reset_dut();
            @(negedge clk);
            en = 1;
            @(negedge clk);
            en = 0;

            #1;


            check_outputs(6'd63);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Multiple Decrements (5 steps)", test_num);
            reset_dut();
            @(negedge clk);
            en = 1;
            repeat(5) @(negedge clk);
            en = 0;

            #1;


            check_outputs(6'd59);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Enable Gating Check", test_num);
            reset_dut();
            @(negedge clk);
            en = 1;
            repeat(2) @(negedge clk);
            en = 0;
            repeat(3) @(negedge clk);
            en = 1;
            @(negedge clk);
            en = 0;
            #1;

            check_outputs(6'd61);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Full Cycle Wrap-around (64 steps)", test_num);
            reset_dut();
            @(negedge clk);
            en = 1;
            repeat(64) @(negedge clk);
            en = 0;

            #1;


            check_outputs(6'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset Priority over Enable", test_num);
            reset_dut();
            @(negedge clk);
            en = 1;
            repeat(10) @(negedge clk);
            rst = 1;
            @(negedge clk);
            rst = 0;
            en = 0;

            #1;


            check_outputs(6'd0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Middle Range Decrement (30 steps)", test_num);
            reset_dut();
            @(negedge clk);
            en = 1;
            repeat(30) @(negedge clk);
            en = 0;

            #1;


            check_outputs(6'd34);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("counter_6bit_down Testbench");
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
        $dumpvars(0,clk, en, rst, q);
    end

endmodule
