`timescale 1ns/1ps

module phase_detector_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] a;
    reg [1:0] b;
    wire [1:0] phase_diff;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    phase_detector dut (
        .a(a),
        .b(b),
        .phase_diff(phase_diff)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: Difference of 0 cycles (00-00)", test_num);
        a = 2'b00; b = 2'b00;
        #1;

        check_outputs(2'b00);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: Difference of 0 cycles (11-11)", test_num);
        a = 2'b11; b = 2'b11;
        #1;

        check_outputs(2'b00);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: Difference of 1 cycle (01-00)", test_num);
        a = 2'b01; b = 2'b00;
        #1;

        check_outputs(2'b01);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: Difference of 1 cycle (10-11)", test_num);
        a = 2'b10; b = 2'b11;
        #1;

        check_outputs(2'b01);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: Difference of 2 cycles (10-00)", test_num);
        a = 2'b10; b = 2'b00;
        #1;

        check_outputs(2'b10);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %0d: Difference of 2 cycles (01-11)", test_num);
        a = 2'b01; b = 2'b11;
        #1;

        check_outputs(2'b10);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test %0d: Difference of 3 cycles (00-11)", test_num);
        a = 2'b00; b = 2'b11;
        #1;

        check_outputs(2'b11);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test %0d: Difference of 3 cycles (11-00)", test_num);
        a = 2'b11; b = 2'b00;
        #1;

        check_outputs(2'b11);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test %0d: Difference of 1 cycle (10-01)", test_num);
        a = 2'b10; b = 2'b01;
        #1;

        check_outputs(2'b01);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Test %0d: Difference of 2 cycles (11-01)", test_num);
        a = 2'b11; b = 2'b01;
        #1;

        check_outputs(2'b10);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("phase_detector Testbench");
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
        testcase010();
        
        
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
        input [1:0] expected_phase_diff;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_phase_diff === (expected_phase_diff ^ phase_diff ^ expected_phase_diff)) begin
                $display("PASS");
                $display("  Outputs: phase_diff=%h",
                         phase_diff);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: phase_diff=%h",
                         expected_phase_diff);
                $display("  Got:      phase_diff=%h",
                         phase_diff);
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
