`timescale 1ns/1ps

module loadable_counter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg load;
    reg [11:0] load_value;
    reg rst;
    wire [11:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    loadable_counter dut (
        .clk(clk),
        .load(load),
        .load_value(load_value),
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
            rst = 1;
            load = 0;
            load_value = 12'b0;
            @(posedge clk);
            #1 rst = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            @(posedge clk);
            #1 #1;
 check_outputs(12'h000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            repeat(10) @(posedge clk);
            #1 #1;
 check_outputs(12'd10);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            load = 1;
            load_value = 12'hA5A;
            @(posedge clk);
            #1;
            load = 0;
            #1;

            check_outputs(12'hA5A);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            load = 1;
            load_value = 12'h100;
            @(posedge clk);
            #1 load = 0;
            repeat(5) @(posedge clk);
            #1 #1;
 check_outputs(12'h105);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            load = 1;
            load_value = 12'hFFF;
            @(posedge clk);
            #1 load = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(12'h000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            load = 1;
            load_value = 12'h777;
            repeat(3) @(posedge clk);
            load_value = 12'h888;
            @(posedge clk);
            #1 #1;
 check_outputs(12'h888);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            load = 1;
            load_value = 12'hFFF;
            @(posedge clk);
            #1;
            rst = 1;
            load = 1;
            load_value = 12'hABC;
            @(posedge clk);
            #1;

            #1;


            check_outputs(12'h000);
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
        input [11:0] expected_count;
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
        $dumpvars(0,clk, load, load_value, rst, count);
    end

endmodule
