`timescale 1ns/1ps

module sync_down_counter_with_load_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg enable;
    reg load;
    reg sync_reset;
    wire [7:0] count_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sync_down_counter_with_load dut (
        .clk(clk),
        .data_in(data_in),
        .enable(enable),
        .load(load),
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
            sync_reset = 1;
            load = 0;
            enable = 0;
            data_in = 8'h00;
            @(posedge clk);
            sync_reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Synchronous Reset", test_num);
            reset_dut();

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Load Data", test_num);
            reset_dut();
            @(posedge clk);
            load = 1;
            data_in = 8'hA5;
            @(posedge clk);
            load = 0;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Simple Count Down", test_num);
            reset_dut();

            @(posedge clk);
            load = 1;
            data_in = 8'd10;
            @(posedge clk);
            load = 0;
            enable = 1;

            repeat (4) @(posedge clk);
            enable = 0;
            #1;

            check_outputs(8'd6);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Rollover (Underflow)", test_num);
            reset_dut();

            @(posedge clk);
            load = 1;
            data_in = 8'd1;
            @(posedge clk);
            load = 0;
            enable = 1;

            repeat (2) @(posedge clk);
            enable = 0;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Enable Control", test_num);
            reset_dut();

            @(posedge clk);
            load = 1;
            data_in = 8'd50;
            @(posedge clk);
            load = 0;
            enable = 1;
            repeat (5) @(posedge clk);
            enable = 0;
            repeat (5) @(posedge clk);
            #1;

            check_outputs(8'd45);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Priority - Reset vs Load", test_num);
            reset_dut();
            @(posedge clk);
            sync_reset = 1;
            load = 1;
            data_in = 8'hFF;
            @(posedge clk);
            sync_reset = 0;
            load = 0;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Priority - Load vs Enable", test_num);
            reset_dut();
            @(posedge clk);
            load = 1;
            enable = 1;
            data_in = 8'hCC;
            @(posedge clk);
            load = 0;
            enable = 0;
            #1;

            check_outputs(8'hCC);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Counting to Zero", test_num);
            reset_dut();
            @(posedge clk);
            load = 1;
            data_in = 8'd3;
            @(posedge clk);
            load = 0;
            enable = 1;
            repeat (3) @(posedge clk);
            enable = 0;
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
        $display("sync_down_counter_with_load Testbench");
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
        $dumpvars(0,clk, data_in, enable, load, sync_reset, count_out);
    end

endmodule
