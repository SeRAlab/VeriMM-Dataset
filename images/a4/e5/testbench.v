`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg sw;
    wire db_level;
    wire db_tick;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .sw(sw),
        .db_level(db_level),
        .db_tick(db_tick)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            sw = 0;
            repeat (2000) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            $display("Test Case %0d: Initial State (sw=0)", test_num);

            #1;


            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            $display("Test Case %0d: Noise Filtering (Short Pulse)", test_num);

            @(negedge clk) sw = 1;
            repeat (20) @(posedge clk);
            @(negedge clk) sw = 0;
            repeat (100) @(posedge clk);


            #1;



            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase003;

        integer timeout;
        begin
            test_num = 3;
            reset_dut();
            $display("Test Case %0d: Valid Press (Stable High)", test_num);

            @(negedge clk) sw = 1;


            timeout = 0;
            while (db_tick === 0 && timeout < 5000) begin
                @(posedge clk);
                timeout = timeout + 1;
            end


            #1;



            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            $display("Test Case %0d: Sustained Level after Tick", test_num);

            @(negedge clk) sw = 1;

            repeat (2000) @(posedge clk);


            #1;



            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            $display("Test Case %0d: Noise Filtering (Glitch while High)", test_num);


            @(negedge clk) sw = 1;
            repeat (2000) @(posedge clk);


            @(negedge clk) sw = 0;
            repeat (20) @(posedge clk);
            @(negedge clk) sw = 1;
            repeat (100) @(posedge clk);


            #1;



            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            $display("Test Case %0d: Valid Switch Release", test_num);


            @(negedge clk) sw = 1;
            repeat (2000) @(posedge clk);


            @(negedge clk) sw = 0;
            repeat (2000) @(posedge clk);


            #1;



            check_outputs(1'b0, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
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
        input expected_db_level;
        input expected_db_tick;
        begin
            if (expected_db_level === (expected_db_level ^ db_level ^ expected_db_level) &&
                expected_db_tick === (expected_db_tick ^ db_tick ^ expected_db_tick)) begin
                $display("PASS");
                $display("  Outputs: db_level=%b, db_tick=%b",
                         db_level, db_tick);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: db_level=%b, db_tick=%b",
                         expected_db_level, expected_db_tick);
                $display("  Got:      db_level=%b, db_tick=%b",
                         db_level, db_tick);
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
        $dumpvars(0,clk, sw, db_level, db_tick);
    end

endmodule
