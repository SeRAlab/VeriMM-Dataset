`timescale 1ns/1ps

module counter_32bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg reset;
    wire [31:0] count;
    wire max_reached;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    counter_32bit dut (
        .clk(clk),
        .enable(enable),
        .reset(reset),
        .count(count),
        .max_reached(max_reached)
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
            @(posedge clk);
            #1 reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Basic Reset functionality", test_num);
            reset_dut();

            #1;


            check_outputs(32'h00000000, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Increment 10 cycles with Enable=1", test_num);
            reset_dut();
            enable = 1;
            repeat(10) @(posedge clk);
            #1;
            #1;

            check_outputs(32'd10, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Counter pause with Enable=0", test_num);
            reset_dut();
            enable = 1;
            repeat(5) @(posedge clk);
            enable = 0;
            repeat(10) @(posedge clk);
            #1;
            #1;

            check_outputs(32'd5, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Reset priority over Enable", test_num);
            reset_dut();
            enable = 1;
            repeat(20) @(posedge clk);
            reset = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'd0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Intermittent Enable toggling", test_num);
            reset_dut();
            enable = 1; @(posedge clk);
            enable = 0; @(posedge clk);
            enable = 1; @(posedge clk);
            enable = 0; @(posedge clk);
            enable = 1; @(posedge clk);
            #1;
            #1;

            check_outputs(32'd3, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Count to 100 cycles", test_num);
            reset_dut();
            enable = 1;
            repeat(100) @(posedge clk);
            #1;
            #1;

            check_outputs(32'd100, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("counter_32bit Testbench");
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
        input [31:0] expected_count;
        input expected_max_reached;
        begin
            if (expected_count === (expected_count ^ count ^ expected_count) &&
                expected_max_reached === (expected_max_reached ^ max_reached ^ expected_max_reached)) begin
                $display("PASS");
                $display("  Outputs: count=%h, max_reached=%b",
                         count, max_reached);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count=%h, max_reached=%b",
                         expected_count, expected_max_reached);
                $display("  Got:      count=%h, max_reached=%b",
                         count, max_reached);
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
        $dumpvars(0,clk, enable, reset, count, max_reached);
    end

endmodule
