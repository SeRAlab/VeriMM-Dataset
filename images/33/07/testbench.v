`timescale 1ns/1ps

module DAC_Controller_tb;

    // Testbench signals (combinational circuit)
    reg [23:0] dac_input;
    wire [7:0] dac_output;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    DAC_Controller dut (
        .dac_input(dac_input),
        .dac_output(dac_output),
        .valid(valid)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Zero Input", test_num);
        dac_input = 24'h000000;
        #1;

        check_outputs(8'h00, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Full Scale Input", test_num);
        dac_input = 24'hFFFFFF;
        #1;

        check_outputs(8'hFF, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Mid-point Input", test_num);
        dac_input = 24'h800000;
        #1;

        check_outputs(8'h80, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Arbitrary Pattern 1", test_num);
        dac_input = 24'hA5A5A5;
        #1;

        check_outputs(8'hA5, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Arbitrary Pattern 2", test_num);
        dac_input = 24'h123456;
        #1;

        check_outputs(8'h12, 1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Low Range Check", test_num);
        dac_input = 24'h01FFFF;
        #1;

        check_outputs(8'h01, 1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: High Range Check", test_num);
        dac_input = 24'hFE0000;
        #1;

        check_outputs(8'hFE, 1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Alternating Bits", test_num);
        dac_input = 24'h555555;
        #1;

        check_outputs(8'h55, 1'b1);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("DAC_Controller Testbench");
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
        input [7:0] expected_dac_output;
        input expected_valid;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_dac_output === (expected_dac_output ^ dac_output ^ expected_dac_output) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: dac_output=%h, valid=%b",
                         dac_output, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dac_output=%h, valid=%b",
                         expected_dac_output, expected_valid);
                $display("  Got:      dac_output=%h, valid=%b",
                         dac_output, valid);
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
