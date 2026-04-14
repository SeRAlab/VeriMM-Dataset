`timescale 1ns/1ps

module counter_enable_load_6_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg load;
    reg [5:0] preset_val;
    reg rst;
    wire [5:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    counter_enable_load_6 dut (
        .clk(clk),
        .enable(enable),
        .load(load),
        .preset_val(preset_val),
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
            $display("Resetting DUT...");
            rst = 1;
            enable = 0;
            load = 0;
            preset_val = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Initial Reset", test_num);
            reset_dut();

            #1;


            check_outputs(6'b000000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Basic Increment (5 cycles)", test_num);
            reset_dut();
            @(negedge clk);
            enable = 1;
            load = 0;

            repeat (5) @(posedge clk);
            #1;
            #1;

            check_outputs(6'd5);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Load Preset Value", test_num);
            reset_dut();
            @(negedge clk);
            preset_val = 6'h2A;
            load = 1;
            enable = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(6'h2A);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Counter Stay Static when Enable is Low", test_num);
            reset_dut();
            @(negedge clk);
            enable = 1;
            repeat (3) @(posedge clk);
            @(negedge clk);
            enable = 0;
            repeat (3) @(posedge clk);
            #1;
            #1;

            check_outputs(6'd3);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Priority Check (Load wins over Enable)", test_num);
            reset_dut();
            @(negedge clk);
            preset_val = 6'h15;
            load = 1;
            enable = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(6'h15);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Counter Rollover (63 to 0)", test_num);
            reset_dut();
            @(negedge clk);
            preset_val = 6'b111111;
            load = 1;
            @(posedge clk);
            @(negedge clk);
            load = 0;
            enable = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(6'b000000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Load then Increment", test_num);
            reset_dut();
            @(negedge clk);
            preset_val = 6'd10;
            load = 1;
            @(posedge clk);
            @(negedge clk);
            load = 0;
            enable = 1;
            repeat (5) @(posedge clk);
            #1;
            #1;

            check_outputs(6'd15);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("counter_enable_load_6 Testbench");
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
        input [5:0] expected_count;
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
        $dumpvars(0,clk, enable, load, preset_val, rst, count);
    end

endmodule
