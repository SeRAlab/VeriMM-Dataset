`timescale 1ns/1ps

module I2C_Controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data;
    reg enable;
    wire SCL;
    wire SDA;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    I2C_Controller dut (
        .clk(clk),
        .data(data),
        .enable(enable),
        .SCL(SCL),
        .SDA(SDA)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            enable = 0;
            data = 8'h00;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Sending 8'h00 (All Zeros)", test_num);
            reset_dut();
            data = 8'h00;
            enable = 1;
            @(posedge clk);
            #2;
            enable = 0;

            #1;


            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Sending 8'hFF (All Ones)", test_num);
            reset_dut();
            data = 8'hFF;
            enable = 1;
            @(posedge clk);
            #2;
            enable = 0;
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Sending 8'hAA (Alternating 10101010)", test_num);
            reset_dut();
            data = 8'hAA;
            enable = 1;
            @(posedge clk);
            #2;
            enable = 0;
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Sending 8'h55 (Alternating 01010101)", test_num);
            reset_dut();
            data = 8'h55;
            enable = 1;
            @(posedge clk);
            #2;
            enable = 0;
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Sending 8'hA5 (Mixed Pattern)", test_num);
            reset_dut();
            data = 8'hA5;
            enable = 1;
            @(posedge clk);
            #2;
            enable = 0;
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %0d: Disable Check (No transmission)", test_num);
            reset_dut();
            data = 8'hFF;
            enable = 0;
            @(posedge clk);
            #2;

            #1;


            check_outputs(1'b1, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("I2C_Controller Testbench");
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
        input expected_SCL;
        input expected_SDA;
        begin
            if (expected_SCL === (expected_SCL ^ SCL ^ expected_SCL) &&
                expected_SDA === (expected_SDA ^ SDA ^ expected_SDA)) begin
                $display("PASS");
                $display("  Outputs: SCL=%b, SDA=%b",
                         SCL, SDA);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: SCL=%b, SDA=%b",
                         expected_SCL, expected_SDA);
                $display("  Got:      SCL=%b, SDA=%b",
                         SCL, SDA);
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
        $dumpvars(0,clk, data, enable, SCL, SDA);
    end

endmodule
