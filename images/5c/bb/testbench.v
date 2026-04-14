`timescale 1ns/1ps

module counter_with_load_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [9:0] data;
    reg load;
    reg reset;
    wire [9:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    counter_with_load dut (
        .clk(clk),
        .data(data),
        .load(load),
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
            @(posedge clk);
            reset <= 1;
            load <= 0;
            data <= 0;
            @(posedge clk);
            reset <= 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Basic increment for 10 cycles", test_num);
            reset_dut();
            repeat(10) @(posedge clk);
            #1;

            check_outputs(10'd10);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Load specific value 10'h123", test_num);
            reset_dut();
            @(posedge clk);
            data <= 10'h123;
            load <= 1;
            @(posedge clk);
            load <= 0;
            #1;

            check_outputs(10'h123);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Load 10'h050 and increment for 5 cycles", test_num);
            reset_dut();
            @(posedge clk);
            data <= 10'h050;
            load <= 1;
            @(posedge clk);
            load <= 0;
            repeat(5) @(posedge clk);
            #1;

            check_outputs(10'h055);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Test wrap-around from 10'h3FF to 0", test_num);
            reset_dut();
            @(posedge clk);
            data <= 10'h3FF;
            load <= 1;
            @(posedge clk);
            load <= 0;
            @(posedge clk);
            #1;

            check_outputs(10'h000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Verify Reset has priority over Load", test_num);
            reset_dut();
            @(posedge clk);
            data <= 10'h1FF;
            load <= 1;
            reset <= 1;
            @(posedge clk);
            reset <= 0;
            load <= 0;
            #1;

            check_outputs(10'h000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Full counter cycle (1024 steps) check", test_num);
            reset_dut();
            repeat(1024) @(posedge clk);
            #1;

            check_outputs(10'd0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Sequential load operations", test_num);
            reset_dut();
            @(posedge clk);
            data <= 10'h0AA;
            load <= 1;
            @(posedge clk);
            data <= 10'h2BB;
            load <= 1;
            @(posedge clk);
            load <= 0;
            #1;

            check_outputs(10'h2BB);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("counter_with_load Testbench");
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
        input [9:0] expected_count;
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
        $dumpvars(0,clk, data, load, reset, count);
    end

endmodule
