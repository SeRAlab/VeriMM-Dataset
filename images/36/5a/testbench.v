`timescale 1ns/1ps

module dvfs_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [2:0] workload;
    wire [1:0] frequency;
    wire [1:0] voltage;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dvfs_controller dut (
        .clk(clk),
        .workload(workload),
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
            workload = 3'b000;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test Case %0d: Workload 000 (Level 0)", test_num);
            workload = 3'b000;
            @(posedge clk);
            #2;
            #1;

            check_outputs(2'b00, 2'b00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test Case %0d: Workload 001 (Level 0)", test_num);
            workload = 3'b001;
            @(posedge clk);
            #2;
            #1;

            check_outputs(2'b00, 2'b00);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test Case %0d: Workload 010 (Level 1)", test_num);
            workload = 3'b010;
            @(posedge clk);
            #2;
            #1;

            check_outputs(2'b01, 2'b01);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test Case %0d: Workload 011 (Level 1)", test_num);
            workload = 3'b011;
            @(posedge clk);
            #2;
            #1;

            check_outputs(2'b01, 2'b01);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test Case %0d: Workload 100 (Level 2)", test_num);
            workload = 3'b100;
            @(posedge clk);
            #2;
            #1;

            check_outputs(2'b10, 2'b10);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test Case %0d: Workload 101 (Level 2)", test_num);
            workload = 3'b101;
            @(posedge clk);
            #2;
            #1;

            check_outputs(2'b10, 2'b10);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test Case %0d: Workload 110 (Level 3)", test_num);
            workload = 3'b110;
            @(posedge clk);
            #2;
            #1;

            check_outputs(2'b11, 2'b11);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test Case %0d: Workload 111 (Level 3)", test_num);
            workload = 3'b111;
            @(posedge clk);
            #2;
            #1;

            check_outputs(2'b11, 2'b11);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test Case %0d: Dynamic Workload Change High -> Low", test_num);


            workload = 3'b111;
            @(posedge clk);
            #2;


            workload = 3'b000;
            @(posedge clk);
            #2;
            #1;

            check_outputs(2'b00, 2'b00);
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
        testcase008();
        testcase009();
        
        
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
        input [1:0] expected_frequency;
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
        $dumpvars(0,clk, workload, frequency, voltage);
    end

endmodule
