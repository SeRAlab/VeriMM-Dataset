`timescale 1ns/1ps

module dvfs_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [2:0] request;
    reg rst;
    wire [2:0] frequency;
    wire [1:0] voltage;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dvfs_controller dut (
        .clk(clk),
        .request(request),
        .rst(rst),
        .frequency(frequency),
        .voltage(voltage)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            request = 0;
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
            $display("\nTestcase %0d: Request Level 0 (0.5V, 100MHz)", test_num);
            reset_dut();
            request = 3'd0;
            repeat(2) @(posedge clk);
            #1 #1;
 check_outputs(3'd0, 2'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Request Level 1 (1.0V, 200MHz)", test_num);
            reset_dut();
            request = 3'd1;
            repeat(2) @(posedge clk);
            #1 #1;
 check_outputs(3'd1, 2'd1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Request Level 2 (1.5V, 300MHz)", test_num);
            reset_dut();
            request = 3'd2;
            repeat(2) @(posedge clk);
            #1 #1;
 check_outputs(3'd2, 2'd2);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Request Level 3 (2.0V, 400MHz)", test_num);
            reset_dut();
            request = 3'd3;
            repeat(2) @(posedge clk);
            #1 #1;
 check_outputs(3'd3, 2'd3);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Request Level 4 (2.5V, 500MHz)", test_num);
            reset_dut();
            request = 3'd4;
            repeat(2) @(posedge clk);

            #1 #1;
 check_outputs(3'd4, 2'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Transition and Hold State", test_num);
            reset_dut();


            request = 3'd2;
            @(posedge clk);



            #1 request = 3'd7;
            repeat(3) @(posedge clk);

            #1 #1;
 check_outputs(3'd2, 2'd2);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Sequential Scaling (Level 1 to 3)", test_num);
            reset_dut();

            request = 3'd1;
            @(posedge clk);
            #1 request = 3'd3;
            @(posedge clk);

            #1 #1;
 check_outputs(3'd3, 2'd3);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("dvfs_controller Testbench");
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
        input [2:0] expected_frequency;
        input [1:0] expected_voltage;
        begin
            if (expected_frequency === (expected_frequency ^ frequency ^ expected_frequency) &&
                expected_voltage === (expected_voltage ^ voltage ^ expected_voltage)) begin
                $display("PASS");
                $display("  Outputs: frequency=%h, voltage=%h",
                         frequency, voltage);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: frequency=%h, voltage=%h",
                         expected_frequency, expected_voltage);
                $display("  Got:      frequency=%h, voltage=%h",
                         frequency, voltage);
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
        $dumpvars(0,clk, request, rst, frequency, voltage);
    end

endmodule
