`timescale 1ns/1ps

module binary_counter_5bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    wire [4:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    binary_counter_5bit dut (
        .clk(clk),
        .rst(rst),
        .count(count)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            @(posedge clk);
            #1;
            rst = 0;

        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Initial Reset Check", test_num);
            reset_dut();
            #1;

            check_outputs(5'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Increment to 5", test_num);
            reset_dut();
            repeat(5) @(posedge clk);
            #1;
            #1;

            check_outputs(5'd5);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Maximum Count Check (31)", test_num);
            reset_dut();
            repeat(31) @(posedge clk);
            #1;
            #1;

            check_outputs(5'd31);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Wrap-around Check (32 cycles)", test_num);
            reset_dut();
            repeat(32) @(posedge clk);
            #1;
            #1;

            check_outputs(5'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Multiple Wraps and Mid-count Reset", test_num);
            reset_dut();

            repeat(66) @(posedge clk);
            #1;

            if (count == 5'd2) begin

                rst = 1;
                @(posedge clk);
                #1;
                rst = 0;
                #1;

                check_outputs(5'd0);
            end else begin
                #1;

                check_outputs(5'd2);
            end
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Continuous Operation (100 cycles)", test_num);
            reset_dut();
            repeat(100) @(posedge clk);
            #1;

            #1;


            check_outputs(5'd4);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("binary_counter_5bit Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        
        
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
        $dumpvars(0,clk, rst, count);
    end

endmodule
