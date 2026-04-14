`timescale 1ns/1ps

module dvfs_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg [4:0] voltage;
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
        voltage = 0;
        @(posedge clk);
        #1;
        reset = 0;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Checking Voltage 0V", test_num);
        reset_dut();
        voltage = 5'd0;
        @(posedge clk);
        #1 #1;
 check_outputs(3'b000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Checking Voltage 3V", test_num);
        reset_dut();
        voltage = 5'd3;
        @(posedge clk);
        #1 #1;
 check_outputs(3'b011);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Checking Voltage 7V", test_num);
        reset_dut();
        voltage = 5'd7;
        @(posedge clk);
        #1 #1;
 check_outputs(3'b111);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Checking Voltage 8V (Saturation)", test_num);
        reset_dut();
        voltage = 5'd8;
        @(posedge clk);
        #1 #1;
 check_outputs(3'b111);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Checking Maximum Voltage 31V", test_num);
        reset_dut();
        voltage = 5'd31;
        @(posedge clk);
        #1 #1;
 check_outputs(3'b111);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Checking Synchronous Update Timing", test_num);
        reset_dut();
        voltage = 5'd2;
        @(posedge clk);
        #1;
        voltage = 5'd5;
        #2;
        if (frequency === 3'd2) begin
            $display("  Sub-check: Frequency held correctly before clock edge.");
            @(posedge clk);
            #1 #1;
 check_outputs(3'b101);
        end else begin
            $display("  Sub-check: FAIL - Frequency changed asynchronously.");
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
