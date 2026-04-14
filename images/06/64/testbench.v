`timescale 1ns/1ps

module DAC_8bit_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] digital_input;
    wire [9:0] analog_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    DAC_8bit dut (
        .digital_input(digital_input),
        .analog_output(analog_output)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Minimum Input (0)", test_num);
        digital_input = 8'h00;
        #1;

        check_outputs(10'h000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Maximum Input (255)", test_num);
        digital_input = 8'hFF;
        #1;

        check_outputs(10'h3FF);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Input 128", test_num);
        digital_input = 8'h80;


        #1;



        check_outputs(10'h202);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Input 64", test_num);
        digital_input = 8'h40;

        #1;


        check_outputs(10'h101);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Input 192", test_num);
        digital_input = 8'hC0;

        #1;


        check_outputs(10'h303);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Input 85 (approx 1/3)", test_num);
        digital_input = 8'h55;


        #1;



        check_outputs(10'h155);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Input 170 (approx 2/3)", test_num);
        digital_input = 8'hAA;

        #1;


        check_outputs(10'h2AA);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Input 1", test_num);
        digital_input = 8'h01;

        #1;


        check_outputs(10'h004);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("DAC_8bit Testbench");
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
        input [9:0] expected_analog_output;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_analog_output === (expected_analog_output ^ analog_output ^ expected_analog_output)) begin
                $display("PASS");
                $display("  Outputs: analog_output=%h",
                         analog_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: analog_output=%h",
                         expected_analog_output);
                $display("  Got:      analog_output=%h",
                         analog_output);
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
