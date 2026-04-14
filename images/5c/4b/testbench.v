`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] signed_mag;
    wire [15:0] twos_comp;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .signed_mag(signed_mag),
        .twos_comp(twos_comp)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Positive Zero", test_num);
        signed_mag = 16'h0000;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Negative Zero", test_num);
        signed_mag = 16'h8000;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Positive Value (+1)", test_num);
        signed_mag = 16'h0001;
        #1;

        check_outputs(16'h0001);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Negative Value (-1)", test_num);
        signed_mag = 16'h8001;
        #1;

        check_outputs(16'hFFFF);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Max Positive (+32767)", test_num);
        signed_mag = 16'h7FFF;
        #1;

        check_outputs(16'h7FFF);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Max Magnitude Negative (-32767)", test_num);
        signed_mag = 16'hFFFF;
        #1;

        check_outputs(16'h8001);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: General Positive (+255)", test_num);
        signed_mag = 16'h00FF;
        #1;

        check_outputs(16'h00FF);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: General Negative (-255)", test_num);
        signed_mag = 16'h80FF;
        #1;

        check_outputs(16'hFF01);
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
        input [15:0] expected_twos_comp;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_twos_comp === (expected_twos_comp ^ twos_comp ^ expected_twos_comp)) begin
                $display("PASS");
                $display("  Outputs: twos_comp=%h",
                         twos_comp);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: twos_comp=%h",
                         expected_twos_comp);
                $display("  Got:      twos_comp=%h",
                         twos_comp);
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
