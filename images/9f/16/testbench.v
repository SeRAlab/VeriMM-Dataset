`timescale 1ns/1ps

module counter_16bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg en;
    wire [15:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    counter_16bit dut (
        .clk(clk),
        .en(en),
        .count(count)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            en = 0;
            @(posedge clk);
            @(negedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Basic 10-cycle Increment", test_num);
            reset_dut();

            en = 1;
            repeat(10) @(posedge clk);
            en = 0;

            expected_val = expected_val + 10;
            #1;
            #1;

            check_outputs(expected_val);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Enable/Disable Toggle Test", test_num);
            reset_dut();


            en = 1;
            repeat(5) @(posedge clk);

            en = 0;
            repeat(5) @(posedge clk);

            en = 1;
            repeat(5) @(posedge clk);
            en = 0;

            expected_val = expected_val + 10;
            #1;
            #1;

            check_outputs(expected_val);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Verify Retention when en=0", test_num);
            reset_dut();

            en = 0;
            repeat(20) @(posedge clk);


            #1;
            #1;

            check_outputs(expected_val);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Single Cycle Pulse", test_num);
            reset_dut();

            en = 1;
            @(posedge clk);
            en = 0;

            expected_val = expected_val + 1;
            #1;
            #1;

            check_outputs(expected_val);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Large Increment (500 cycles)", test_num);
            reset_dut();

            en = 1;
            repeat(500) @(posedge clk);
            en = 0;

            expected_val = expected_val + 500;
            #1;
            #1;

            check_outputs(expected_val);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("counter_16bit Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        
        
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
        input [15:0] expected_count;
        begin
            if (expected_count === (expected_count ^ count ^ expected_count)) begin
                $display("PASS");
                $display("  Outputs: count=%h",
                         count);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count=%h",
                         expected_count);
                $display("  Got:      count=%h",
                         count);
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
        $dumpvars(0,clk, en, count);
    end

endmodule
