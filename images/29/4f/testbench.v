`timescale 1ns/1ps

module linear_voltage_regulator_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [4:0] ref_voltage;
    reg reset;
    wire [4:0] regulated_voltage;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    linear_voltage_regulator dut (
        .clk(clk),
        .ref_voltage(ref_voltage),
        .reset(reset),
        .regulated_voltage(regulated_voltage)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            ref_voltage = 5'b0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Reset functionality", test_num);
            reset_dut();

            #1;


            check_outputs(5'b00000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Tracking Mid-range (15)", test_num);
            reset_dut();
            ref_voltage = 5'd15;

            repeat(10) @(posedge clk);
            #1;
            #1;

            check_outputs(5'd15);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Tracking Maximum Range (31)", test_num);
            reset_dut();
            ref_voltage = 5'd31;
            repeat(32) @(posedge clk);
            #1;
            #1;

            check_outputs(5'd31);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Tracking Minimum Range (1)", test_num);
            reset_dut();
            ref_voltage = 5'd1;
            repeat(10) @(posedge clk);
            #1;
            #1;

            check_outputs(5'd1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Transition from High to Low voltage", test_num);
            reset_dut();

            ref_voltage = 5'd25;
            repeat(32) @(posedge clk);

            ref_voltage = 5'd5;
            repeat(32) @(posedge clk);
            #1;
            #1;

            check_outputs(5'd5);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %0d: Reset activation during active regulation", test_num);
            reset_dut();
            ref_voltage = 5'd20;
            repeat(5) @(posedge clk);
            reset = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(5'b00000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("linear_voltage_regulator Testbench");
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
        input [4:0] expected_regulated_voltage;
        begin
            if (expected_regulated_voltage === (expected_regulated_voltage ^ regulated_voltage ^ expected_regulated_voltage)) begin
                $display("PASS");
                $display("  Outputs: regulated_voltage=%h",
                         regulated_voltage);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: regulated_voltage=%h",
                         expected_regulated_voltage);
                $display("  Got:      regulated_voltage=%h",
                         regulated_voltage);
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
        $dumpvars(0,clk, ref_voltage, reset, regulated_voltage);
    end

endmodule
