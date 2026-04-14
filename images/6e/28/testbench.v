`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] din1;
    reg [2:0] din2;
    wire din2_din1_denorm;
    wire din2_din1_nz;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .din1(din1),
        .din2(din2),
        .din2_din1_denorm(din2_din1_denorm),
        .din2_din1_nz(din2_din1_nz)
    );
    task testcase001;

    begin
        test_num = 1;
        din1 = 3'b000; din2 = 3'b000;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        din1 = 3'b001; din2 = 3'b011;
        #1;

        check_outputs(1'b1, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        din1 = 3'b100; din2 = 3'b111;
        #1;

        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        din1 = 3'b010; din2 = 3'b101;
        #1;

        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        din1 = 3'b000; din2 = 3'b001;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        din1 = 3'b110; din2 = 3'b000;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        din1 = 3'b100; din2 = 3'b011;
        #1;

        check_outputs(1'b0, 1'b1);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
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
        input expected_din2_din1_denorm;
        input expected_din2_din1_nz;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_din2_din1_denorm === (expected_din2_din1_denorm ^ din2_din1_denorm ^ expected_din2_din1_denorm) &&
                expected_din2_din1_nz === (expected_din2_din1_nz ^ din2_din1_nz ^ expected_din2_din1_nz)) begin
                $display("PASS");
                $display("  Outputs: din2_din1_denorm=%b, din2_din1_nz=%b",
                         din2_din1_denorm, din2_din1_nz);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: din2_din1_denorm=%b, din2_din1_nz=%b",
                         expected_din2_din1_denorm, expected_din2_din1_nz);
                $display("  Got:      din2_din1_denorm=%b, din2_din1_nz=%b",
                         din2_din1_denorm, din2_din1_nz);
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
