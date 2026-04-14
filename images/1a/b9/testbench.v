`timescale 1ns/1ps

module timer_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg [15:0] limit;
    reg reset;
    wire limit_reached;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    timer dut (
        .clk(clk),
        .enable(enable),
        .limit(limit),
        .reset(reset),
        .limit_reached(limit_reached)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            enable = 0;
            limit = 16'h0000;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Count to 10", test_num);
            reset_dut();
            limit = 16'd10;
            enable = 1;
            repeat(10) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Disabled counter", test_num);
            reset_dut();
            limit = 16'd10;
            enable = 0;
            repeat(15) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Interrupted count (Enable toggle)", test_num);
            reset_dut();
            limit = 16'd5;
            enable = 1;
            repeat(3) @(posedge clk);
            enable = 0;
            repeat(5) @(posedge clk);
            enable = 1;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Mid-count Reset", test_num);
            reset_dut();
            limit = 16'd10;
            enable = 1;
            repeat(8) @(posedge clk);
            reset = 1;
            @(posedge clk);
            #1 reset = 0;
            repeat(5) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Count to 100", test_num);
            reset_dut();
            limit = 16'd100;
            enable = 1;
            repeat(100) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Limit of 1", test_num);
            reset_dut();
            limit = 16'd1;
            enable = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Changing limit mid-count", test_num);
            reset_dut();
            limit = 16'd20;
            enable = 1;
            repeat(5) @(posedge clk);
            limit = 16'd5;
            #1;
            #1;

            check_outputs(1'b1);
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
        input expected_limit_reached;
        begin
            if (expected_limit_reached === (expected_limit_reached ^ limit_reached ^ expected_limit_reached)) begin
                $display("PASS");
                $display("  Outputs: limit_reached=%b",
                         limit_reached);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: limit_reached=%b",
                         expected_limit_reached);
                $display("  Got:      limit_reached=%b",
                         limit_reached);
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
        $dumpvars(0,clk, enable, limit, reset, limit_reached);
    end

endmodule
