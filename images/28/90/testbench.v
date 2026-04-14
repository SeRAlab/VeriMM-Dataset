`timescale 1ns/1ps

module DAC_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] binary_in;
    wire [7:0] analog_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    DAC dut (
        .binary_in(binary_in),
        .analog_out(analog_out)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Minimum value (0V)", test_num);
        binary_in = 8'h00;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Maximum value (5V)", test_num);
        binary_in = 8'hFF;
        #1;

        check_outputs(8'hFF);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Mid-scale value (~2.5V)", test_num);
        binary_in = 8'h80;
        #1;

        check_outputs(8'h80);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Quarter-scale value (~1.25V)", test_num);
        binary_in = 8'h40;
        #1;

        check_outputs(8'h40);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Three-quarter scale value (~3.75V)", test_num);
        binary_in = 8'hC0;
        #1;

        check_outputs(8'hC0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Smallest step (LSB)", test_num);
        binary_in = 8'h01;
        #1;

        check_outputs(8'h01);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Arbitrary pattern 0xAA", test_num);
        binary_in = 8'hAA;
        #1;

        check_outputs(8'hAA);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: Arbitrary pattern 0x55", test_num);
        binary_in = 8'h55;
        #1;

        check_outputs(8'h55);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("DAC Testbench");
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
        input [7:0] expected_analog_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_analog_out === (expected_analog_out ^ analog_out ^ expected_analog_out)) begin
                $display("PASS");
                $display("  Outputs: analog_out=%h",
                         analog_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: analog_out=%h",
                         expected_analog_out);
                $display("  Got:      analog_out=%h",
                         analog_out);
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
