`timescale 1ns/1ps

module dvfs_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg [2:0] voltage;
    wire [2:0] frequency;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dvfs_controller dut (
        .clk(clk),
        .reset(reset),
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
            reset = 1;
            voltage = 3'b000;
            @(posedge clk);
            #2;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            voltage = 3'b011;
            @(posedge clk);
            #1;
            $display("Test Case 001: Voltage = 3'b011 (Threshold)");
            #1;

            check_outputs(3'b011);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            voltage = 3'b010;
            @(posedge clk);
            #1;
            $display("Test Case 002: Voltage = 3'b010 (Below Threshold)");
            #1;

            check_outputs(3'b001);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            voltage = 3'b001;
            @(posedge clk);
            #1;
            $display("Test Case 003: Voltage = 3'b001 (Below Threshold)");
            #1;

            check_outputs(3'b000);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            voltage = 3'b101;
            @(posedge clk);
            #1;
            $display("Test Case 004: Voltage = 3'b101 (Above Threshold)");
            #1;

            check_outputs(3'b101);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            voltage = 3'b111;
            @(posedge clk);
            #1;
            $display("Test Case 005: Voltage = 3'b111 (Max)");
            #1;

            check_outputs(3'b111);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            voltage = 3'b000;
            @(posedge clk);
            #1;
            $display("Test Case 006: Voltage = 3'b000 (Minimum, Underflow)");
            #1;

            check_outputs(3'b111);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;
            voltage = 3'b110;
            @(posedge clk);
            #1;
            voltage = 3'b010;
            #2;

            $display("Test Case 007: Stability Check (Before Clock Edge)");
            if (frequency === 3'b110) begin
                @(posedge clk);
                #1;
                $display("Test Case 007: Stability Check (After Clock Edge)");
                #1;

                check_outputs(3'b001);
            end else begin
                $display("FAIL: Frequency changed without clock edge");
                fail_count = fail_count + 1;
            end
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
        $dumpvars(0,clk, reset, voltage, frequency);
    end

endmodule
