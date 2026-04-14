`timescale 1ns/1ps

module down_counter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg [4:0] initial_value;
    reg reset;
    wire [4:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    down_counter dut (
        .clk(clk),
        .enable(enable),
        .initial_value(initial_value),
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
            #5;
            reset = 0;
            @(negedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Reset to initial value", test_num);
            initial_value = 5'h1F;
            enable = 0;
            reset_dut();
            #1;

            check_outputs(5'h1F);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Basic decrement (10 -> 7)", test_num);
            initial_value = 5'h0A;
            enable = 0;
            reset_dut();

            @(negedge clk);
            enable = 1;
            repeat (3) @(negedge clk);
            enable = 0;

            #1;


            check_outputs(5'h07);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Enable signal check", test_num);
            initial_value = 5'h0F;
            enable = 0;
            reset_dut();

            repeat (5) @(negedge clk);

            #1;


            check_outputs(5'h0F);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Count down to zero", test_num);
            initial_value = 5'h03;
            enable = 0;
            reset_dut();

            @(negedge clk);
            enable = 1;
            repeat (3) @(negedge clk);
            enable = 0;

            #1;


            check_outputs(5'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Wrap-around check (1 -> 0 -> 31)", test_num);
            initial_value = 5'h01;
            enable = 0;
            reset_dut();

            @(negedge clk);
            enable = 1;
            repeat (2) @(negedge clk);
            enable = 0;

            #1;


            check_outputs(5'h1F);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Mid-operation asynchronous reset", test_num);
            initial_value = 5'h14;
            enable = 0;
            reset_dut();

            @(negedge clk);
            enable = 1;
            repeat (5) @(negedge clk);


            initial_value = 5'h05;
            #2 reset = 1;
            #5 reset = 0;

            @(negedge clk);
            #1;

            check_outputs(5'h05);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Intermittent enable check", test_num);
            initial_value = 5'h10;
            reset_dut();

            @(negedge clk) enable = 1;
            @(negedge clk) enable = 0;
            @(negedge clk) enable = 0;
            @(negedge clk) enable = 1;
            @(negedge clk) enable = 0;

            #1;


            check_outputs(5'h0E);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("down_counter Testbench");
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
        input [4:0] expected_count;
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
        $dumpvars(0,clk, enable, initial_value, reset, count);
    end

endmodule
