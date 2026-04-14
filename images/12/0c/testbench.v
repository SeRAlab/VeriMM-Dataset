`timescale 1ns/1ps

module DVFS_Controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg [1:0] workload;
    wire [1:0] freq_sel;
    wire [1:0] volt_sel;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    DVFS_Controller dut (
        .clk(clk),
        .reset(reset),
        .workload(workload),
        .freq_sel(freq_sel),
        .volt_sel(volt_sel)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            workload = 2'b00;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Low Load Mode", test_num);
            reset_dut();
            workload = 2'b00;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(2'b00, 2'b00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Medium Load Mode", test_num);
            reset_dut();
            workload = 2'b01;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(2'b01, 2'b01);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: High Load Mode", test_num);
            reset_dut();
            workload = 2'b10;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(2'b10, 2'b10);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Alternative High Load Mode", test_num);
            reset_dut();
            workload = 2'b11;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(2'b10, 2'b10);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Low to High Transition", test_num);
            reset_dut();
            workload = 2'b00;
            @(posedge clk);
            workload = 2'b10;
            repeat(3) @(posedge clk);
            #1;

            check_outputs(2'b10, 2'b10);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: High to Medium Transition", test_num);
            reset_dut();
            workload = 2'b10;
            @(posedge clk);
            workload = 2'b01;
            repeat(3) @(posedge clk);
            #1;

            check_outputs(2'b01, 2'b01);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("DVFS_Controller Testbench");
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
        input [1:0] expected_freq_sel;
        input [1:0] expected_volt_sel;
        begin
            if (expected_freq_sel === (expected_freq_sel ^ freq_sel ^ expected_freq_sel) &&
                expected_volt_sel === (expected_volt_sel ^ volt_sel ^ expected_volt_sel)) begin
                $display("PASS");
                $display("  Outputs: freq_sel=%h, volt_sel=%h",
                         freq_sel, volt_sel);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: freq_sel=%h, volt_sel=%h",
                         expected_freq_sel, expected_volt_sel);
                $display("  Got:      freq_sel=%h, volt_sel=%h",
                         freq_sel, volt_sel);
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
        $dumpvars(0,clk, reset, workload, freq_sel, volt_sel);
    end

endmodule
