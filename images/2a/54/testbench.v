`timescale 1ns/1ps

module ADC_16bit_tb;

    // Testbench signals (combinational circuit)
    reg enable;
    reg [7:0] voltage_in;
    wire [15:0] voltage_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ADC_16bit dut (
        .enable(enable),
        .voltage_in(voltage_in),
        .voltage_out(voltage_out)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Disabled, voltage_in = 0x00", test_num);
            enable = 1'b0;
            voltage_in = 8'h00;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Disabled, voltage_in = 0xFF", test_num);
            enable = 1'b0;
            voltage_in = 8'hFF;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Enabled, voltage_in = 0x00", test_num);
            enable = 1'b1;
            voltage_in = 8'h00;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Enabled, voltage_in = 0xFF", test_num);
            enable = 1'b1;
            voltage_in = 8'hFF;
            #1;

            check_outputs(16'h00FF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Enabled, voltage_in = 0x55 (Alternating bits)", test_num);
            enable = 1'b1;
            voltage_in = 8'h55;
            #1;

            check_outputs(16'h0055);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Enabled, voltage_in = 0xAA (Alternating bits)", test_num);
            enable = 1'b1;
            voltage_in = 8'hAA;
            #1;

            check_outputs(16'h00AA);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Enabled, voltage_in = 0x80 (Most significant bit only)", test_num);
            enable = 1'b1;
            voltage_in = 8'h80;
            #1;

            check_outputs(16'h0080);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: Switch from Enabled to Disabled mid-stream", test_num);
            enable = 1'b1;
            voltage_in = 8'h12;
            #5;
            enable = 1'b0;
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
        $display("ADC_16bit Testbench");
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
        input [15:0] expected_voltage_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_voltage_out === (expected_voltage_out ^ voltage_out ^ expected_voltage_out)) begin
                $display("PASS");
                $display("  Outputs: voltage_out=%h",
                         voltage_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: voltage_out=%h",
                         expected_voltage_out);
                $display("  Got:      voltage_out=%h",
                         voltage_out);
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
