`timescale 1ns/1ps

module timer_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg load;
    reg [15:0] max_value;
    reg rst;
    wire [15:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    timer dut (
        .clk(clk),
        .enable(enable),
        .load(load),
        .max_value(max_value),
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
            enable = 0;
            load = 0;
            max_value = 16'h0000;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Reset", test_num);
            reset_dut();

            #1;


            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Counting", test_num);
            reset_dut();
            max_value = 16'h00FF;
            enable = 1;

            repeat (5) @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0005);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Load Value", test_num);
            reset_dut();
            max_value = 16'hA5A5;
            load = 1;
            @(posedge clk);
            #1;
            load = 0;
            #1;

            check_outputs(16'hA5A5);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Enable Control", test_num);
            reset_dut();
            max_value = 16'h00FF;
            enable = 1;
            repeat (3) @(posedge clk);
            #1;
            enable = 0;
            repeat (3) @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0003);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Wrap Around", test_num);
            reset_dut();
            max_value = 16'h0003;
            enable = 1;




            repeat (4) @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Load and Wrap", test_num);
            reset_dut();
            max_value = 16'h000A;
            load = 1;
            @(posedge clk);
            #1;
            load = 0;
            enable = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset Priority", test_num);
            reset_dut();
            max_value = 16'hFFFF;
            enable = 1;
            load = 1;
            rst = 1;
            repeat (2) @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Dynamic Max Value Update", test_num);
            reset_dut();
            max_value = 16'h0005;
            enable = 1;
            repeat (3) @(posedge clk);
            #1;
            max_value = 16'h0003;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("timer Testbench");
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
        input [15:0] expected_count;
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
        $dumpvars(0,clk, enable, load, max_value, rst, count);
    end

endmodule
