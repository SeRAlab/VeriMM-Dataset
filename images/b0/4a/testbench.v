`timescale 1ns/1ps

module sync_down_counter_zero_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg sync_reset;
    wire [7:0] count_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sync_down_counter_zero dut (
        .clk(clk),
        .enable(enable),
        .sync_reset(sync_reset),
        .count_out(count_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(posedge clk);
            sync_reset <= 1;
            enable <= 0;
            @(posedge clk);
            sync_reset <= 0;
            $display("Task: reset_dut - Module Reset Completed");
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning testcase001: Verify Synchronous Reset...");
            test_num = test_num + 1;
            reset_dut();

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning testcase002: Single decrement wrap around (0 -> FF)...");
            test_num = test_num + 1;
            reset_dut();
            @(posedge clk);
            enable <= 1;
            @(posedge clk);
            enable <= 0;

            #1;


            check_outputs(8'hFF);
        end
        endtask

    task testcase003;

        integer i;
        begin
            $display("\nRunning testcase003: Multiple decrements (10 cycles)...");
            test_num = test_num + 1;
            reset_dut();
            @(posedge clk);
            enable <= 1;
            repeat (10) @(posedge clk);
            enable <= 0;

            #1;


            check_outputs(8'hF6);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning testcase004: Verify counter holds when enable is low...");
            test_num = test_num + 1;
            reset_dut();
            @(posedge clk);
            enable <= 1;
            repeat (5) @(posedge clk);
            enable <= 0;
            repeat (5) @(posedge clk);

            #1;


            check_outputs(8'hFB);
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning testcase005: Verify 256 decrements return to zero...");
            test_num = test_num + 1;
            reset_dut();
            @(posedge clk);
            enable <= 1;
            repeat (256) @(posedge clk);
            enable <= 0;

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase006;

        begin
            $display("\nRunning testcase006: Verify sync reset priority over enable...");
            test_num = test_num + 1;
            reset_dut();
            @(posedge clk);
            enable <= 1;
            repeat (5) @(posedge clk);
            sync_reset <= 1;
            @(posedge clk);
            sync_reset <= 0;
            enable <= 0;

            #1;


            check_outputs(8'h00);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sync_down_counter_zero Testbench");
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
        $dumpvars(0,clk, enable, sync_reset, count_out);
    end

endmodule
