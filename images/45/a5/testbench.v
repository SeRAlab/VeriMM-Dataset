`timescale 1ns/1ps

module async_down_counter_tb;

    // Testbench signals (sequential circuit)
    reg async_reset;
    reg clk;
    reg enable;
    wire [7:0] count_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    async_down_counter dut (
        .async_reset(async_reset),
        .clk(clk),
        .enable(enable),
        .count_out(count_out)
    );

    // Clock generation (10ns period)
    initial begin
        async_reset = 0;
        forever #5 async_reset = ~async_reset;
    end

        task reset_dut;

        begin
            async_reset = 1;
            enable = 0;
            #15;
            async_reset = 0;
            #5;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Reset Check", test_num);
            reset_dut();

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Single Step Down (Wrap to 0xFF)", test_num);
            reset_dut();
            enable = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Multiple Steps Down", test_num);
            reset_dut();
            enable = 1;
            repeat(10) @(posedge clk);
            #1;
            #1;

            check_outputs(8'hF6);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Enable Signal Logic", test_num);
            reset_dut();
            enable = 1;
            repeat(5) @(posedge clk);
            enable = 0;
            repeat(5) @(posedge clk);
            #1;
            #1;

            check_outputs(8'hFB);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Full Wrap-around (256 cycles)", test_num);
            reset_dut();
            enable = 1;
            repeat(256) @(posedge clk);
            #1;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Asynchronous Reset Mid-Operation", test_num);
            reset_dut();
            enable = 1;
            repeat(15) @(posedge clk);
            #2;
            async_reset = 1;
            #1;
            #1;

            check_outputs(8'h00);
            async_reset = 0;
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Complex Enable/Count Sequence", test_num);
            reset_dut();
            enable = 1;
            repeat(100) @(posedge clk);
            enable = 0;
            repeat(10) @(posedge clk);
            enable = 1;
            repeat(6) @(posedge clk);
            #1;
            #1;

            check_outputs(8'h96);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("async_down_counter Testbench");
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
        input [7:0] expected_count_out;
        begin
            if (expected_count_out === (expected_count_out ^ count_out ^ expected_count_out)) begin
                $display("PASS");
                $display("  Outputs: count_out=%h",
                         count_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count_out=%h",
                         expected_count_out);
                $display("  Got:      count_out=%h",
                         count_out);
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
        $dumpvars(0,async_reset, clk, enable, count_out);
    end

endmodule
