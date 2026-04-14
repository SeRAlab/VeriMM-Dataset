`timescale 1ns/1ps

module down_counter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg down_en;
    reg [3:0] initial_value;
    reg reset;
    wire [3:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    down_counter dut (
        .clk(clk),
        .down_en(down_en),
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
            reset = 1;
            down_en = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Basic Reset", test_num);
            initial_value = 4'd10;
            reset_dut();
            #1;

            check_outputs(4'd10);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Single Decrement", test_num);
            initial_value = 4'd15;
            reset_dut();
            down_en = 1;
            @(posedge clk);
            #1;
            down_en = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd14);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Multiple Decrements", test_num);
            initial_value = 4'd5;
            reset_dut();
            down_en = 1;
            repeat(3) @(posedge clk);
            #1;
            down_en = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd2);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Enable Disabled Check", test_num);
            initial_value = 4'd8;
            reset_dut();
            down_en = 0;
            repeat(4) @(posedge clk);
            #1;
            #1;

            check_outputs(4'd8);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Count to Zero", test_num);
            initial_value = 4'd3;
            reset_dut();
            down_en = 1;
            repeat(3) @(posedge clk);
            #1;
            down_en = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Wrap Around (0 to 15)", test_num);
            initial_value = 4'd1;
            reset_dut();
            down_en = 1;
            repeat(2) @(posedge clk);
            #1;
            down_en = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'hF);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case %0d: Interleaved Enable", test_num);
            initial_value = 4'd12;
            reset_dut();

            down_en = 1; @(posedge clk); #1;
            down_en = 0; @(posedge clk); #1;
            down_en = 1; @(posedge clk); #1;
            down_en = 1; @(posedge clk); #1;
            down_en = 0; @(posedge clk); #1;

            #1;


            check_outputs(4'd9);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test Case %0d: Reset Priority over Enable", test_num);
            initial_value = 4'd7;
            reset_dut();

            down_en = 1;
            @(posedge clk);
            #1;
            reset = 1;
            @(posedge clk);
            #1;
            reset = 0;
            down_en = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd7);
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
        $dumpvars(0,clk, down_en, initial_value, reset, count);
    end

endmodule
