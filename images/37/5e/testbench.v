`timescale 1ns/1ps

module adc_converter_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] binary_input;
    reg valid;
    wire [15:0] hex_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    adc_converter dut (
        .binary_input(binary_input),
        .valid(valid),
        .hex_output(hex_output)
    );
    task testcase001;

        begin
            test_num = 1;

            valid = 1;
            binary_input = 16'h0000;
            #10;


            binary_input = 16'h1234;
            valid = 1;
            #10;

            #1;


            check_outputs(16'h1234);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;

            valid = 1;
            binary_input = 16'hAAAA;
            #10;


            valid = 0;
            binary_input = 16'hBBBB;
            #10;


            #1;



            check_outputs(16'hAAAA);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;

            valid = 1;
            binary_input = 16'h0000;
            #10;


            binary_input = 16'hFFFF;
            valid = 1;
            #10;

            #1;


            check_outputs(16'hFFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;

            valid = 1;
            binary_input = 16'h5555;
            #10;
            valid = 0;
            binary_input = 16'h6666;
            #10;


            valid = 1;
            #10;


            #1;



            check_outputs(16'h6666);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;

            valid = 1;
            binary_input = 16'h0000;
            #10;

            binary_input = 16'h1111;
            #5;
            binary_input = 16'h2222;
            #5;
            binary_input = 16'h3333;
            #10;

            #1;


            check_outputs(16'h3333);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;

            valid = 1;
            binary_input = 16'hFFFF;
            #10;

            binary_input = 16'h0000;
            valid = 1;
            #10;

            #1;


            check_outputs(16'h0000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("adc_converter Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        
        
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
        input [15:0] expected_hex_output;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_hex_output === (expected_hex_output ^ hex_output ^ expected_hex_output)) begin
                $display("PASS");
                $display("  Outputs: hex_output=%h",
                         hex_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: hex_output=%h",
                         expected_hex_output);
                $display("  Got:      hex_output=%h",
                         hex_output);
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
