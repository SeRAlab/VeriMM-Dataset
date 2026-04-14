`timescale 1ns/1ps

module pipeline_adder_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] in_a;
    reg [31:0] in_b;
    reg rst;
    wire [31:0] out_sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pipeline_adder dut (
        .clk(clk),
        .in_a(in_a),
        .in_b(in_b),
        .rst(rst),
        .out_sum(out_sum)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            in_a = 0;
            in_b = 0;
            repeat(2) @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Basic Addition (100 + 200)", test_num);
            reset_dut();
            in_a = 32'd100;
            in_b = 32'd200;
            @(posedge clk);

            in_a = 0;
            in_b = 0;

            repeat(6) @(posedge clk);
            #1;
            #1;

            check_outputs(32'd300);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Zero Addition (0 + 0)", test_num);
            reset_dut();
            in_a = 32'h0;
            in_b = 32'h0;
            @(posedge clk);
            repeat(6) @(posedge clk);
            #1;
            #1;

            check_outputs(32'h0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Overflow Wrap Around (0xFFFFFFFF + 1)", test_num);
            reset_dut();
            in_a = 32'hFFFF_FFFF;
            in_b = 32'h0000_0001;
            @(posedge clk);
            repeat(6) @(posedge clk);
            #1;
            #1;

            check_outputs(32'h0000_0000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Large Hex Addition", test_num);
            reset_dut();
            in_a = 32'h1234_5678;
            in_b = 32'h1111_1111;
            @(posedge clk);
            repeat(6) @(posedge clk);
            #1;
            #1;

            check_outputs(32'h2345_6789);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Alternating Bit Pattern", test_num);
            reset_dut();
            in_a = 32'hAAAA_AAAA;
            in_b = 32'h5555_5555;
            @(posedge clk);
            repeat(6) @(posedge clk);
            #1;
            #1;

            check_outputs(32'hFFFF_FFFF);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("pipeline_adder Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        
        
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
        input [31:0] expected_out_sum;
        begin
            if (expected_out_sum === (expected_out_sum ^ out_sum ^ expected_out_sum)) begin
                $display("PASS");
                $display("  Outputs: out_sum=%h",
                         out_sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_sum=%h",
                         expected_out_sum);
                $display("  Got:      out_sum=%h",
                         out_sum);
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
        $dumpvars(0,clk, in_a, in_b, rst, out_sum);
    end

endmodule
