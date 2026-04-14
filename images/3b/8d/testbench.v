`timescale 1ns/1ps

module ADC_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] voltage_input;
    wire [2:0] range_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ADC dut (
        .voltage_input(voltage_input),
        .range_output(range_output)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: Range 0 Lower Boundary (0)", test_num);
        voltage_input = 8'd0;
        #1;

        check_outputs(3'b000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: Range 0 Middle Value (42)", test_num);
        voltage_input = 8'd42;
        #1;

        check_outputs(3'b000);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: Range 0 Upper Boundary (84)", test_num);
        voltage_input = 8'd84;
        #1;

        check_outputs(3'b000);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: Range 1 Lower Boundary (85)", test_num);
        voltage_input = 8'd85;
        #1;

        check_outputs(3'b001);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: Range 1 Middle Value (127)", test_num);
        voltage_input = 8'd127;
        #1;

        check_outputs(3'b001);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %0d: Range 1 Upper Boundary (169)", test_num);
        voltage_input = 8'd169;
        #1;

        check_outputs(3'b001);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test %0d: Range 2 Lower Boundary (170)", test_num);
        voltage_input = 8'd170;
        #1;

        check_outputs(3'b010);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test %0d: Range 2 Middle Value (212)", test_num);
        voltage_input = 8'd212;
        #1;

        check_outputs(3'b010);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test %0d: Range 2 Upper Boundary (255)", test_num);
        voltage_input = 8'd255;
        #1;

        check_outputs(3'b010);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ADC Testbench");
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
        input [2:0] expected_range_output;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_range_output === (expected_range_output ^ range_output ^ expected_range_output)) begin
                $display("PASS");
                $display("  Outputs: range_output=%h",
                         range_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: range_output=%h",
                         expected_range_output);
                $display("  Got:      range_output=%h",
                         range_output);
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
