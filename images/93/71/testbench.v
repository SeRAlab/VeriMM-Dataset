`timescale 1ns/1ps

module up_counter_8bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg en;
    reg rst;
    wire [7:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    up_counter_8bit dut (
        .clk(clk),
        .en(en),
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
            $display("Test %0d: Reset verification", test_num);
            reset_dut();

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Basic increment (10 cycles)", test_num);
            reset_dut();
            en = 1;
            repeat(10) @(negedge clk);
            en = 0;
            #1;

            check_outputs(8'd10);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Enable/Disable functionality", test_num);
            reset_dut();
            en = 1;
            repeat(5) @(negedge clk);
            en = 0;
            repeat(5) @(negedge clk);
            #1;

            check_outputs(8'd5);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Counter overflow wrap-around", test_num);
            reset_dut();
            en = 1;
            repeat(256) @(negedge clk);
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Synchronous reset while enabled", test_num);
            reset_dut();
            en = 1;
            repeat(15) @(negedge clk);
            rst = 1;
            @(negedge clk);
            rst = 0;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Post-wrap-around counting", test_num);
            reset_dut();
            en = 1;
            repeat(260) @(negedge clk);
            en = 0;
            #1;

            check_outputs(8'd4);
        end
        endtask

    task testcase007;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Test %0d: Enable toggling stress test", test_num);
            reset_dut();
            for(i=0; i<10; i=i+1) begin
                en = 1; @(negedge clk);
                en = 0; @(negedge clk);
            end

            #1;


            check_outputs(8'd10);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("up_counter_8bit Testbench");
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
        $dumpvars(0,clk, en, rst, count);
    end

endmodule
