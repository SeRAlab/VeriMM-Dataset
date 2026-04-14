`timescale 1ns/1ps

module power_gating_control_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] data;
    reg enable;
    wire [3:0] output_data;
    wire power_gated;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    power_gating_control dut (
        .data(data),
        .enable(enable),
        .output_data(output_data),
        .power_gated(power_gated)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Power On - Data 4'hA", test_num);
        data = 4'hA;
        enable = 1'b1;
        #1;

        check_outputs(4'hA, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Power Off - Data 4'hA", test_num);
        data = 4'hA;
        enable = 1'b0;
        #1;

        check_outputs(4'h0, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Power On - Data 4'h0", test_num);
        data = 4'h0;
        enable = 1'b1;
        #1;

        check_outputs(4'h0, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Power On - Data 4'hF", test_num);
        data = 4'hF;
        enable = 1'b1;
        #1;

        check_outputs(4'hF, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Power Off - Data 4'hF", test_num);
        data = 4'hF;
        enable = 1'b0;
        #1;

        check_outputs(4'h0, 1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Transition Off to On", test_num);

        enable = 1'b0;
        data = 4'h5;
        #5;

        enable = 1'b1;
        #1;

        check_outputs(4'h5, 1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Transition On to Off", test_num);

        enable = 1'b1;
        data = 4'hC;
        #5;

        enable = 1'b0;
        #1;

        check_outputs(4'h0, 1'b0);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("power_gating_control Testbench");
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
        input [3:0] expected_output_data;
        input expected_power_gated;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_output_data === (expected_output_data ^ output_data ^ expected_output_data) &&
                expected_power_gated === (expected_power_gated ^ power_gated ^ expected_power_gated)) begin
                $display("PASS");
                $display("  Outputs: output_data=%h, power_gated=%b",
                         output_data, power_gated);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: output_data=%h, power_gated=%b",
                         expected_output_data, expected_power_gated);
                $display("  Got:      output_data=%h, power_gated=%b",
                         output_data, power_gated);
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
