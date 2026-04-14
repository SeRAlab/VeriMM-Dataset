`timescale 1ns/1ps

module up_down_counter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg reset;
    wire [3:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    up_down_counter dut (
        .clk(clk),
        .enable(enable),
        .reset(reset),
        .count(count)
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
            enable = 0;
            @(negedge clk);
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Reset behavior", test_num);
            reset_dut();

            #1;


            check_outputs(4'h0);
        end
        endtask

    task testcase002;

        integer i;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Increment 5 times", test_num);
            reset_dut();
            enable = 1;
            for (i = 0; i < 5; i = i + 1) begin
                @(negedge clk);
            end
            #1;

            check_outputs(4'h5);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Decrement from 0 (Underflow)", test_num);
            reset_dut();
            enable = 0;
            for (i = 0; i < 3; i = i + 1) begin
                @(negedge clk);
            end

            #1;


            check_outputs(4'hD);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Increment to Overflow (18 cycles)", test_num);
            reset_dut();
            enable = 1;
            for (i = 0; i < 18; i = i + 1) begin
                @(negedge clk);
            end

            #1;


            check_outputs(4'h2);
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Mixed Up (10) then Down (4)", test_num);
            reset_dut();
            enable = 1;
            for (i = 0; i < 10; i = i + 1) @(negedge clk);
            enable = 0;
            for (i = 0; i < 4; i = i + 1) @(negedge clk);

            #1;


            check_outputs(4'h6);
        end
        endtask

    task testcase006;

        integer i;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Increment to Maximum (15)", test_num);
            reset_dut();
            enable = 1;
            for (i = 0; i < 15; i = i + 1) @(negedge clk);
            #1;

            check_outputs(4'hF);
        end
        endtask

    task testcase007;

        integer i;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Decrement 20 times", test_num);
            reset_dut();
            enable = 0;
            for (i = 0; i < 20; i = i + 1) @(negedge clk);

            #1;


            check_outputs(4'hC);
        end
        endtask

    task testcase008;

        integer i;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Full wrap around Up (16 cycles)", test_num);
            reset_dut();
            enable = 1;
            for (i = 0; i < 16; i = i + 1) @(negedge clk);
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase009;

        integer i;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Full wrap around Down (16 cycles)", test_num);
            reset_dut();
            enable = 0;
            for (i = 0; i < 16; i = i + 1) @(negedge clk);
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase010;

        integer i;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Synchronous Reset override during count", test_num);
            reset_dut();
            enable = 1;
            for (i = 0; i < 5; i = i + 1) @(negedge clk);

            reset = 1;
            @(negedge clk);
            reset = 0;
            #1;

            check_outputs(4'h0);
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
        testcase007();
        testcase008();
        testcase009();
        testcase010();
        
        
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
        input [3:0] expected_count;
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
        $dumpvars(0,clk, enable, reset, count);
    end

endmodule
