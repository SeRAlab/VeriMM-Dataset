`timescale 1ns/1ps

module adc_8bit_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] control;
    wire [7:0] adc_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    adc_8bit dut (
        .control(control),
        .adc_output(adc_output)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Control = 000", test_num);
            control = 3'b000;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Control = 001", test_num);
            control = 3'b001;
            #1;

            check_outputs(8'h20);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Control = 010", test_num);
            control = 3'b010;
            #1;

            check_outputs(8'h40);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Control = 011", test_num);
            control = 3'b011;
            #1;

            check_outputs(8'h60);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Control = 100", test_num);
            control = 3'b100;
            #1;

            check_outputs(8'h80);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Control = 101", test_num);
            control = 3'b101;
            #1;

            check_outputs(8'hA0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case %0d: Control = 110", test_num);
            control = 3'b110;
            #1;

            check_outputs(8'hC0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test Case %0d: Control = 111", test_num);
            control = 3'b111;
            #1;

            check_outputs(8'hE0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("adc_8bit Testbench");
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
        input [7:0] expected_adc_output;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_adc_output === (expected_adc_output ^ adc_output ^ expected_adc_output)) begin
                $display("PASS");
                $display("  Outputs: adc_output=%h",
                         adc_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: adc_output=%h",
                         expected_adc_output);
                $display("  Got:      adc_output=%h",
                         adc_output);
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
