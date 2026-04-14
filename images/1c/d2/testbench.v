`timescale 1ns/1ps

module dvfs_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [1:0] voltage;
    wire [31:0] frequency;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dvfs_controller dut (
        .clk(clk),
        .voltage(voltage),
        .frequency(frequency)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            voltage = 2'b00;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Testing Voltage 0 (Range 0-1V) -> 1GHz", test_num);
            voltage = 2'd0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'd1000000000);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Testing Voltage 1 (Range 1-2V) -> 2GHz", test_num);
            voltage = 2'd1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'd2000000000);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Testing Voltage 2 (Range >2V) -> 3GHz", test_num);
            voltage = 2'd2;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'd3000000000);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Testing Voltage 3 (Range >2V) -> 3GHz", test_num);
            voltage = 2'd3;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'd3000000000);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Testing Voltage Transition (0 -> 2)", test_num);


            voltage = 2'd0;
            @(posedge clk);


            voltage = 2'd2;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'd3000000000);
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
        input [31:0] expected_frequency;
        begin
            if (expected_frequency === (expected_frequency ^ frequency ^ expected_frequency)) begin
                $display("PASS");
                $display("  Outputs: frequency=%h",
                         frequency);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: frequency=%h",
                         expected_frequency);
                $display("  Got:      frequency=%h",
                         frequency);
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
        $dumpvars(0,clk, voltage, frequency);
    end

endmodule
