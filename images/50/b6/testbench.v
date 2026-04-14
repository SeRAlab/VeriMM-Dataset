`timescale 1ns/1ps

module loadable_counter_with_enable_sync_reset_7bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg load;
    reg [6:0] load_value;
    reg reset;
    wire [6:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    loadable_counter_with_enable_sync_reset_7bit dut (
        .clk(clk),
        .enable(enable),
        .load(load),
        .load_value(load_value),
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
            reset = 1;
            enable = 0;
            load = 0;
            load_value = 0;
            @(posedge clk);
            reset = 0;
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Synchronous Reset", test_num);
            reset_dut();
            #1;

            check_outputs(7'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Basic Increment with Enable", test_num);
            reset_dut();
            @(posedge clk);
            enable = 1;
            repeat (10) @(posedge clk);
            enable = 0;
            #1;
            #1;

            check_outputs(7'd10);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Load Value", test_num);
            reset_dut();
            @(posedge clk);
            load = 1;
            load_value = 7'h5A;
            @(posedge clk);
            load = 0;
            #1;
            #1;

            check_outputs(7'h5A);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Reset Priority", test_num);
            reset_dut();
            @(posedge clk);
            reset = 1;
            load = 1;
            enable = 1;
            load_value = 7'h7F;
            @(posedge clk);
            reset = 0;
            #1;
            #1;

            check_outputs(7'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Load Priority Over Enable", test_num);
            reset_dut();
            @(posedge clk);
            load = 1;
            enable = 1;
            load_value = 7'h20;
            @(posedge clk);
            load = 0;
            #1;
            #1;

            check_outputs(7'h20);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Counter Wrap-around (127 to 0)", test_num);
            reset_dut();
            @(posedge clk);
            load = 1;
            load_value = 7'd127;
            @(posedge clk);
            load = 0;
            enable = 1;
            @(posedge clk);
            enable = 0;
            #1;
            #1;

            check_outputs(7'd0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case %0d: Disable Counter (Hold value)", test_num);
            reset_dut();
            @(posedge clk);
            load = 1;
            load_value = 7'd42;
            @(posedge clk);
            load = 0;
            enable = 0;
            repeat (5) @(posedge clk);
            #1;
            #1;

            check_outputs(7'd42);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test Case %0d: Load then Increment", test_num);
            reset_dut();
            @(posedge clk);
            load = 1;
            load_value = 7'd100;
            @(posedge clk);
            load = 0;
            enable = 1;
            repeat (5) @(posedge clk);
            enable = 0;
            #1;
            #1;

            check_outputs(7'd105);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("loadable_counter_with_enable_sync_reset_7bit Testbench");
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
        input [6:0] expected_count;
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
        $dumpvars(0,clk, enable, load, load_value, reset, count);
    end

endmodule
