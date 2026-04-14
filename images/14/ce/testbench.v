`timescale 1ns/1ps

module dvfs_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg [3:0] workload;
    wire [1:0] frequency_level;
    wire [1:0] voltage_level;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dvfs_controller dut (
        .clk(clk),
        .reset(reset),
        .workload(workload),
        .frequency_level(frequency_level),
        .voltage_level(voltage_level)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            workload = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Minimum workload scenario", test_num);
            reset_dut();

            workload = 4'd0;
            repeat(2) @(posedge clk);
            #1;


            #1;



            check_outputs(2'b01, 2'b01);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Maximum workload scenario", test_num);
            reset_dut();

            workload = 4'd15;
            repeat(2) @(posedge clk);
            #1;


            #1;



            check_outputs(2'b10, 2'b10);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Moderate low workload", test_num);
            reset_dut();

            workload = 4'd4;
            repeat(2) @(posedge clk);
            #1;


            #1;



            check_outputs(2'b01, 2'b01);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Moderate high workload", test_num);
            reset_dut();

            workload = 4'd12;
            repeat(2) @(posedge clk);
            #1;


            #1;



            check_outputs(2'b10, 2'b10);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Transition Low to High", test_num);
            reset_dut();


            workload = 4'd2;
            @(posedge clk);


            workload = 4'd14;
            repeat(2) @(posedge clk);
            #1;


            #1;



            check_outputs(2'b10, 2'b10);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Transition High to Low", test_num);
            reset_dut();


            workload = 4'd13;
            @(posedge clk);


            workload = 4'd1;
            repeat(2) @(posedge clk);
            #1;


            #1;



            check_outputs(2'b01, 2'b01);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Upper boundary check", test_num);
            reset_dut();

            workload = 4'd8;
            repeat(2) @(posedge clk);
            #1;


            #1;



            check_outputs(2'b10, 2'b10);
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
        input [1:0] expected_frequency_level;
        input [1:0] expected_voltage_level;
        begin
            if (expected_frequency_level === (expected_frequency_level ^ frequency_level ^ expected_frequency_level) &&
                expected_voltage_level === (expected_voltage_level ^ voltage_level ^ expected_voltage_level)) begin
                $display("PASS");
                $display("  Outputs: frequency_level=%h, voltage_level=%h",
                         frequency_level, voltage_level);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: frequency_level=%h, voltage_level=%h",
                         expected_frequency_level, expected_voltage_level);
                $display("  Got:      frequency_level=%h, voltage_level=%h",
                         frequency_level, voltage_level);
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
        $dumpvars(0,clk, reset, workload, frequency_level, voltage_level);
    end

endmodule
