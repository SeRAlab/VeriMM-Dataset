`timescale 1ns/1ps

module DAC_8bit_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] binary_in;
    wire [11:0] analog_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    DAC_8bit dut (
        .binary_in(binary_in),
        .analog_out(analog_out)
    );
    task testcase001;

    begin
        test_num = 1;
        binary_in = 8'h00;
        #10;
        $display("Testcase %0d: Input = %d (Min)", test_num, binary_in);
        #1;

        check_outputs(12'h000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        binary_in = 8'hFF;
        #10;
        $display("Testcase %0d: Input = %d (Max)", test_num, binary_in);
        #1;

        check_outputs(12'hFF0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        binary_in = 8'h80;
        #10;
        $display("Testcase %0d: Input = %d (Mid)", test_num, binary_in);
        #1;

        check_outputs(12'h800);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        binary_in = 8'h40;
        #10;
        $display("Testcase %0d: Input = %d (Quarter)", test_num, binary_in);
        #1;

        check_outputs(12'h400);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        binary_in = 8'h01;
        #10;
        $display("Testcase %0d: Input = %d (LSB)", test_num, binary_in);
        #1;

        check_outputs(12'h010);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        binary_in = 8'd200;
        #10;
        $display("Testcase %0d: Input = %d", test_num, binary_in);
        #1;

        check_outputs(12'd3200);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        binary_in = 8'hAA;
        #10;
        $display("Testcase %0d: Input = 0xAA", test_num);
        #1;

        check_outputs(12'hAA0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        binary_in = 8'h55;
        #10;
        $display("Testcase %0d: Input = 0x55", test_num);
        #1;

        check_outputs(12'h550);
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
        input [11:0] expected_analog_out;
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
