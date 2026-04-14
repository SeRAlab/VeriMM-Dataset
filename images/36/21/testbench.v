`timescale 1ns/1ps

module chacha_counter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] counter;
    reg [31:0] key;
    reg reset;
    wire [31:0] output_value;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    chacha_counter dut (
        .clk(clk),
        .counter(counter),
        .key(key),
        .reset(reset),
        .output_value(output_value)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            $display("Resetting DUT...");
            reset = 1;
            key = 0;
            counter = 0;
            @(posedge clk);
            #2;
            reset = 0;
            @(posedge clk);
            #2;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase %0d: Basic Addition (10 + 20)", test_num);
            @(negedge clk);
            key = 32'd10;
            counter = 32'd20;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'd30);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase %0d: Zero Case (0 + 0)", test_num);
            @(negedge clk);
            key = 32'h0;
            counter = 32'h0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'h0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase %0d: Overflow Case (Max + 1)", test_num);
            @(negedge clk);
            key = 32'hFFFFFFFF;
            counter = 32'h1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'h0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase %0d: Max values wrap (Max + Max)", test_num);
            @(negedge clk);
            key = 32'hFFFFFFFF;
            counter = 32'hFFFFFFFF;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'hFFFFFFFE);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase %0d: Large Hex values", test_num);
            @(negedge clk);
            key = 32'h12345678;
            counter = 32'h87654321;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'h99999999);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("Testcase %0d: Power of 2 sum", test_num);
            @(negedge clk);
            key = 32'h80000000;
            counter = 32'h80000000;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;
            $display("Testcase %0d: Alternating bits (0xAAAA + 0x5555)", test_num);
            @(negedge clk);
            key = 32'hAAAAAAAA;
            counter = 32'h55555555;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("chacha_counter Testbench");
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
        input [31:0] expected_output_value;
        begin
            if (expected_output_value === (expected_output_value ^ output_value ^ expected_output_value)) begin
                $display("PASS");
                $display("  Outputs: output_value=%h",
                         output_value);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: output_value=%h",
                         expected_output_value);
                $display("  Got:      output_value=%h",
                         output_value);
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
        $dumpvars(0,clk, counter, key, reset, output_value);
    end

endmodule
