`timescale 1ns/1ps

module pipeline_adder_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_a;
    reg [7:0] data_b;
    reg rst;
    wire [7:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pipeline_adder dut (
        .clk(clk),
        .data_a(data_a),
        .data_b(data_b),
        .rst(rst),
        .result(result)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            data_a = 8'h00;
            data_b = 8'h00;

            repeat(2) @(posedge clk);
            #1 rst = 0;

            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTest %0d: Basic Addition (10 + 20)", test_num);
            reset_dut();

            data_a = 8'd10;
            data_b = 8'd20;


            repeat(5) @(posedge clk);

            #1 #1;
 check_outputs(8'd30);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTest %0d: Zero Addition (0 + 0)", test_num);
            reset_dut();

            data_a = 8'h00;
            data_b = 8'h00;

            repeat(5) @(posedge clk);

            #1 #1;
 check_outputs(8'h00);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTest %0d: Maximum 8-bit Sum (127 + 128)", test_num);
            reset_dut();

            data_a = 8'd127;
            data_b = 8'd128;

            repeat(5) @(posedge clk);

            #1 #1;
 check_outputs(8'hFF);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTest %0d: Overflow Wrap-around (200 + 100)", test_num);
            reset_dut();

            data_a = 8'd200;
            data_b = 8'd100;

            repeat(5) @(posedge clk);


            #1 #1;
 check_outputs(8'd44);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTest %0d: Alternating Bit Pattern (0x55 + 0xAA)", test_num);
            reset_dut();

            data_a = 8'h55;
            data_b = 8'hAA;

            repeat(5) @(posedge clk);

            #1 #1;
 check_outputs(8'hFF);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTest %0d: Reset during operation", test_num);
            reset_dut();

            data_a = 8'd50;
            data_b = 8'd50;


            repeat(2) @(posedge clk);


            rst = 1;
            repeat(2) @(posedge clk);
            rst = 0;


            repeat(5) @(posedge clk);


            #1 #1;
 check_outputs(8'h00);
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
        input [7:0] expected_result;
        begin
            if (expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: result=%h",
                         result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result=%h",
                         expected_result);
                $display("  Got:      result=%h",
                         result);
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
        $dumpvars(0,clk, data_a, data_b, rst, result);
    end

endmodule
