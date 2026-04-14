`timescale 1ns/1ps

module adc_controller_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] adc_data;
    reg clk;
    reg rst;
    wire [15:0] avg_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    adc_controller dut (
        .adc_data(adc_data),
        .clk(clk),
        .rst(rst),
        .avg_output(avg_output)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        adc_data = 0;
        @(posedge clk);
        #1 rst = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: All Zeros", test_num);
        reset_dut();
        repeat(8) begin
            adc_data = 16'h0000;
            @(posedge clk);
        end
        #2 #1;
 check_outputs(16'h0000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Constant Value (0x0A00)", test_num);
        reset_dut();
        repeat(8) begin
            adc_data = 16'h0A00;
            @(posedge clk);
        end
        #2 #1;
 check_outputs(16'h0A00);
    end
        endtask

    task testcase003;

    integer i;
    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Linear Sequence", test_num);
        reset_dut();
        for (i = 1; i <= 8; i = i + 1) begin
            adc_data = i * 10;
            @(posedge clk);
        end
        #2 #1;
 check_outputs(16'd45);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Buffer Wrap-around", test_num);
        reset_dut();

        repeat(8) begin
            adc_data = 16'hFFFF;
            @(posedge clk);
        end

        repeat(8) begin
            adc_data = 16'h1111;
            @(posedge clk);
        end
        #2 #1;
 check_outputs(16'h1111);
    end
        endtask

    task testcase005;

    integer i;
    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Truncation Check", test_num);
        reset_dut();
        repeat(7) begin
            adc_data = 16'd1;
            @(posedge clk);
        end
        adc_data = 16'd0;
        @(posedge clk);
        #2 #1;
 check_outputs(16'd0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Maximum Values", test_num);
        reset_dut();
        repeat(8) begin
            adc_data = 16'hFFFF;
            @(posedge clk);
        end
        #2 #1;
 check_outputs(16'hFFFF);
    end
        endtask

    task testcase007;

    integer i;
    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Alternating High/Low", test_num);
        reset_dut();
        repeat(4) begin
            adc_data = 16'd400;
            @(posedge clk);
        end
        repeat(4) begin
            adc_data = 16'd0;
            @(posedge clk);
        end
        #2 #1;
 check_outputs(16'd200);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("adc_controller Testbench");
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
        input [15:0] expected_avg_output;
        begin
            if (expected_avg_output === (expected_avg_output ^ avg_output ^ expected_avg_output)) begin
                $display("PASS");
                $display("  Outputs: avg_output=%h",
                         avg_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: avg_output=%h",
                         expected_avg_output);
                $display("  Got:      avg_output=%h",
                         avg_output);
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
        $dumpvars(0,adc_data, clk, rst, avg_output);
    end

endmodule
