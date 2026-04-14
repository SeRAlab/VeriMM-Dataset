`timescale 1ns/1ps

module adc_8bit_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] control;
    wire [7:0] digital_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    adc_8bit dut (
        .control(control),
        .digital_out(digital_out)
    );
    task testcase001;

    begin
        $display("Test Case 001: Control = 000 (Analog 0)");
        test_num = 1;
        control = 3'b000;
        #1;

        check_outputs(8'b00000001);
    end
        endtask

    task testcase002;

    begin
        $display("Test Case 002: Control = 001 (Analog 1)");
        test_num = 2;
        control = 3'b001;
        #1;

        check_outputs(8'b00000010);
    end
        endtask

    task testcase003;

    begin
        $display("Test Case 003: Control = 010 (Analog 2)");
        test_num = 3;
        control = 3'b010;
        #1;

        check_outputs(8'b00000100);
    end
        endtask

    task testcase004;

    begin
        $display("Test Case 004: Control = 011 (Analog 3)");
        test_num = 4;
        control = 3'b011;
        #1;

        check_outputs(8'b00001000);
    end
        endtask

    task testcase005;

    begin
        $display("Test Case 005: Control = 100 (Analog 4)");
        test_num = 5;
        control = 3'b100;
        #1;

        check_outputs(8'b00010000);
    end
        endtask

    task testcase006;

    begin
        $display("Test Case 006: Control = 101 (Analog 5)");
        test_num = 6;
        control = 3'b101;
        #1;

        check_outputs(8'b00100000);
    end
        endtask

    task testcase007;

    begin
        $display("Test Case 007: Control = 110 (Analog 6)");
        test_num = 7;
        control = 3'b110;
        #1;

        check_outputs(8'b01000000);
    end
        endtask

    task testcase008;

    begin
        $display("Test Case 008: Control = 111 (Analog 7)");
        test_num = 8;
        control = 3'b111;
        #1;

        check_outputs(8'b10000000);
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
        input [7:0] expected_digital_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_digital_out === (expected_digital_out ^ digital_out ^ expected_digital_out)) begin
                $display("PASS");
                $display("  Outputs: digital_out=%h",
                         digital_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: digital_out=%h",
                         expected_digital_out);
                $display("  Got:      digital_out=%h",
                         digital_out);
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
