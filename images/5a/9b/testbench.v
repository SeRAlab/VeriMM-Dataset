`timescale 1ns/1ps

module loadable_counter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg load;
    reg [11:0] load_value;
    reg reset_n;
    wire [11:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    loadable_counter dut (
        .clk(clk),
        .load(load),
        .load_value(load_value),
        .reset_n(reset_n),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset_n = 0;
            load = 0;
            load_value = 0;
            #15;
            reset_n = 1;
            #5;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Reset behavior", test_num);
            reset_dut();

            #1;


            check_outputs(12'h000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Synchronous Load", test_num);
            reset_dut();
            @(posedge clk);
            load = 1;
            load_value = 12'hABC;
            @(posedge clk);
            #1;
            load = 0;
            #1;

            check_outputs(12'hABC);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Incrementing after reset", test_num);
            reset_dut();

            repeat(10) @(posedge clk);
            #1;
            #1;

            check_outputs(12'd10);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Incrementing from a loaded value", test_num);
            reset_dut();
            @(posedge clk);
            load = 1;
            load_value = 12'h500;
            @(posedge clk);
            load = 0;
            repeat(5) @(posedge clk);
            #1;
            #1;

            check_outputs(12'h505);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Rollover from 0xFFF to 0x000", test_num);
            reset_dut();
            @(posedge clk);
            load = 1;
            load_value = 12'hFFF;
            @(posedge clk);
            load = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(12'h000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %0d: Load takes precedence over counting", test_num);
            reset_dut();
            @(posedge clk);
            load = 1;
            load_value = 12'h123;
            @(posedge clk);
            load_value = 12'h456;
            @(posedge clk);
            #1;
            load = 0;
            #1;

            check_outputs(12'h456);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("\nTestcase %0d: Loading and checking max value 0xFFF", test_num);
            reset_dut();
            @(posedge clk);
            load = 1;
            load_value = 12'hFFF;
            @(posedge clk);
            #1;
            load = 0;
            #1;

            check_outputs(12'hFFF);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("loadable_counter Testbench");
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
        input [11:0] expected_q;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%h",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h",
                         expected_q);
                $display("  Got:      q=%h",
                         q);
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
        $dumpvars(0,clk, load, load_value, reset_n, q);
    end

endmodule
