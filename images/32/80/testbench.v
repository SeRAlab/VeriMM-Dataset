`timescale 1ns/1ps

module DVFS_Controller_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] workload;
    wire [1:0] freq_control;
    wire [1:0] volt_control;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    DVFS_Controller dut (
        .workload(workload),
        .freq_control(freq_control),
        .volt_control(volt_control)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: Workload 000 (Minimum Workload)", test_num);
        workload = 3'b000;
        #1;

        check_outputs(2'b00, 2'b00);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: Workload 001", test_num);
        workload = 3'b001;
        #1;

        check_outputs(2'b00, 2'b00);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: Workload 010", test_num);
        workload = 3'b010;
        #1;

        check_outputs(2'b01, 2'b01);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: Workload 011", test_num);
        workload = 3'b011;
        #1;

        check_outputs(2'b01, 2'b01);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: Workload 100", test_num);
        workload = 3'b100;
        #1;

        check_outputs(2'b10, 2'b10);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %0d: Workload 101", test_num);
        workload = 3'b101;
        #1;

        check_outputs(2'b10, 2'b10);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test %0d: Workload 110", test_num);
        workload = 3'b110;
        #1;

        check_outputs(2'b11, 2'b11);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test %0d: Workload 111 (Maximum Workload)", test_num);
        workload = 3'b111;
        #1;

        check_outputs(2'b11, 2'b11);
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
        testcase007();
        testcase008();
        
        
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
        input [1:0] expected_freq_control;
        input [1:0] expected_volt_control;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_freq_control === (expected_freq_control ^ freq_control ^ expected_freq_control) &&
                expected_volt_control === (expected_volt_control ^ volt_control ^ expected_volt_control)) begin
                $display("PASS");
                $display("  Outputs: freq_control=%h, volt_control=%h",
                         freq_control, volt_control);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: freq_control=%h, volt_control=%h",
                         expected_freq_control, expected_volt_control);
                $display("  Got:      freq_control=%h, volt_control=%h",
                         freq_control, volt_control);
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

endmodule
