`timescale 1ns/1ps

module power_gating_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] data_input;
    reg power_enable;
    wire [4:0] data_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    power_gating dut (
        .data_input(data_input),
        .power_enable(power_enable),
        .data_output(data_output)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Power Disabled, Input Zero", test_num);
            power_enable = 1'b0;
            data_input = 5'b00000;
            #1;

            check_outputs(5'b00000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Power Disabled, Input Max (Gating Check)", test_num);
            power_enable = 1'b0;
            data_input = 5'b11111;
            #1;

            check_outputs(5'b00000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Power Disabled, Input Pattern 5'h0A", test_num);
            power_enable = 1'b0;
            data_input = 5'h0A;
            #1;

            check_outputs(5'b00000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Power Enabled, Input Zero", test_num);
            power_enable = 1'b1;
            data_input = 5'b00000;
            #1;

            check_outputs(5'b00000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Power Enabled, Input Pattern 5'h15", test_num);
            power_enable = 1'b1;
            data_input = 5'h15;
            #1;

            check_outputs(5'h15);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Power Enabled, Input Pattern 5'h0A", test_num);
            power_enable = 1'b1;
            data_input = 5'h0A;
            #1;

            check_outputs(5'h0A);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Power Enabled, Input Max", test_num);
            power_enable = 1'b1;
            data_input = 5'b11111;
            #1;

            check_outputs(5'b11111);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: Dynamic Power Gating Transition (On to Off)", test_num);
            power_enable = 1'b1;
            data_input = 5'h1F;
            #5;
            power_enable = 1'b0;
            #1;

            check_outputs(5'b00000);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test %0d: Dynamic Power Gating Transition (Off to On)", test_num);
            power_enable = 1'b0;
            data_input = 5'h12;
            #5;
            power_enable = 1'b1;
            #1;

            check_outputs(5'h12);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("power_gating Testbench");
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
        input [4:0] expected_data_output;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_data_output === (expected_data_output ^ data_output ^ expected_data_output)) begin
                $display("PASS");
                $display("  Outputs: data_output=%h",
                         data_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_output=%h",
                         expected_data_output);
                $display("  Got:      data_output=%h",
                         data_output);
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
