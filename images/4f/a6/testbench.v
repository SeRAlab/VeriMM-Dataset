`timescale 1ns/1ps

module counter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg en;
    wire [7:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    counter dut (
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
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Single Increment", test_num);
            reset_dut();
            local_expected = count + 1;
            en = 1;
            @(posedge clk);
            #1;
            en = 0;
            #1;

            check_outputs(local_expected);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Enable Low (Hold Value)", test_num);
            reset_dut();
            local_expected = count;
            en = 0;
            repeat(5) @(posedge clk);
            #1;
            #1;

            check_outputs(local_expected);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Multiple Increments (10 cycles)", test_num);
            reset_dut();
            local_expected = count + 10;
            en = 1;
            repeat(10) @(posedge clk);
            #1;
            en = 0;
            #1;

            check_outputs(local_expected);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Intermittent Enable", test_num);
            reset_dut();
            local_expected = count;
            for (i = 0; i < 5; i = i + 1) begin
                en = 1; @(posedge clk); #1;
                en = 0; @(posedge clk); #1;
                local_expected = local_expected + 1;
            end
            #1;

            check_outputs(local_expected);
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Counter Roll-over (8-bit)", test_num);
            reset_dut();



            local_expected = count + 8'd256;
            en = 1;
            repeat(256) @(posedge clk);
            #1;
            en = 0;
            #1;

            check_outputs(local_expected);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("counter Testbench");
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
        input [7:0] expected_count;
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
