`timescale 1ns/1ps

module counter2bit_en_tc_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg en;
    reg rst;
    wire [1:0] q;
    wire tc;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    counter2bit_en_tc dut (
        .clk(clk),
        .en(en),
        .rst(rst),
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
            en = 0;
            @(negedge clk);
            rst = 0;
            @(negedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Reset State Verification", test_num);
            reset_dut();

            #1;


            check_outputs(2'b00, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Single Increment (0 to 1)", test_num);
            reset_dut();
            en = 1;
            @(negedge clk);
            en = 0;

            #1;


            check_outputs(2'b01, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Terminal Count Check (Count to 3)", test_num);
            reset_dut();
            en = 1;
            repeat(3) @(negedge clk);
            en = 0;

            #1;


            check_outputs(2'b11, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Wrap-around Check (Count to 4)", test_num);
            reset_dut();
            en = 1;
            repeat(4) @(negedge clk);
            en = 0;

            #1;


            check_outputs(2'b00, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Enable Gating Check", test_num);
            reset_dut();
            en = 1;
            @(negedge clk);
            en = 0;
            @(negedge clk);
            @(negedge clk);

            #1;


            check_outputs(2'b01, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Mid-count Reset Check", test_num);
            reset_dut();
            en = 1;
            repeat(2) @(negedge clk);
            rst = 1;
            @(negedge clk);
            rst = 0;

            #1;


            check_outputs(2'b00, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Full Cycle Continuous Count", test_num);
            reset_dut();
            en = 1;
            repeat(5) @(negedge clk);
            en = 0;

            #1;


            check_outputs(2'b01, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("counter2bit_en_tc Testbench");
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
        input [1:0] expected_q;
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
        $dumpvars(0,clk, en, rst, q, tc);
    end

endmodule
