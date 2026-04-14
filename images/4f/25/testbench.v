`timescale 1ns/1ps

module binary_counter_sync_preset_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg preset;
    wire [3:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    binary_counter_sync_preset dut (
        .clk(clk),
        .enable(enable),
        .preset(preset),
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
            preset = 1;
            enable = 0;
            @(negedge clk);
            preset = 0;
            enable = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Basic Synchronous Preset", test_num);
            reset_dut();


            #1;



            check_outputs(4'd5);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Incrementing (5 -> 8)", test_num);
            reset_dut();
            @(negedge clk);
            enable = 1;
            repeat(3) @(negedge clk);
            enable = 0;
            #1;

            check_outputs(4'd8);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Enable Gating", test_num);
            reset_dut();
            @(negedge clk);
            enable = 0;
            repeat(3) @(negedge clk);
            #1;

            check_outputs(4'd5);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Wrap-around (5 -> 15 -> 0)", test_num);
            reset_dut();
            @(negedge clk);
            enable = 1;
            repeat(11) @(negedge clk);
            enable = 0;
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Preset Priority Over Enable", test_num);
            reset_dut();
            @(negedge clk);
            enable = 1;
            @(negedge clk);


            preset = 1;
            enable = 1;
            @(negedge clk);

            preset = 0;
            enable = 0;
            #1;

            check_outputs(4'd5);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Continuous Count to 15", test_num);
            reset_dut();
            @(negedge clk);
            enable = 1;
            repeat(10) @(negedge clk);
            enable = 0;
            #1;

            check_outputs(4'd15);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("binary_counter_sync_preset Testbench");
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
        $dumpvars(0,clk, enable, preset, count);
    end

endmodule
