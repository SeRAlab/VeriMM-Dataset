`timescale 1ns/1ps

module sync_counter_with_load_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg load;
    reg [7:0] parallel_in;
    reg sync_reset;
    wire [7:0] count_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sync_counter_with_load dut (
        .clk(clk),
        .enable(enable),
        .load(load),
        .parallel_in(parallel_in),
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
        sync_reset = 1;
        enable = 0;
        load = 0;
        parallel_in = 8'h00;
        @(posedge clk);
        #1;
        sync_reset = 0;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Testing Synchronous Reset", test_num);
        reset_dut();
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Testing Parallel Load", test_num);
        reset_dut();
        @(negedge clk);
        parallel_in = 8'hA5;
        load = 1;
        @(posedge clk);
        #1;
        load = 0;
        #1;

        check_outputs(8'hA5);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Testing 5-cycle Increment", test_num);
        reset_dut();
        @(negedge clk);
        enable = 1;
        repeat(5) @(posedge clk);
        #1;
        enable = 0;
        #1;

        check_outputs(8'd5);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Testing Enable Gating", test_num);
        reset_dut();
        @(negedge clk);
        enable = 0;
        repeat(10) @(posedge clk);
        #1;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Testing Reset Priority over Load", test_num);
        reset_dut();
        @(negedge clk);
        parallel_in = 8'hFF;
        load = 1;
        sync_reset = 1;
        @(posedge clk);
        #1;
        sync_reset = 0;
        load = 0;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Testing Load Priority over Enable", test_num);
        reset_dut();
        @(negedge clk);
        parallel_in = 8'h77;
        load = 1;
        enable = 1;
        @(posedge clk);
        #1;
        load = 0;
        enable = 0;
        #1;

        check_outputs(8'h77);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Testing Counter Rollover (255->0)", test_num);
        reset_dut();
        @(negedge clk);
        parallel_in = 8'hFF;
        load = 1;
        @(posedge clk);
        #1;
        load = 0;
        enable = 1;
        @(posedge clk);
        #1;
        enable = 0;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Testing Load followed by sequence", test_num);
        reset_dut();
        @(negedge clk);
        parallel_in = 8'h10;
        load = 1;
        @(posedge clk);
        #1;
        load = 0;
        enable = 1;
        repeat(16) @(posedge clk);
        #1;
        enable = 0;
        #1;

        check_outputs(8'h20);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sync_counter_with_load Testbench");
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
        $dumpvars(0,clk, enable, load, parallel_in, sync_reset, count_out);
    end

endmodule
