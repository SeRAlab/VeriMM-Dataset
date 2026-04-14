`timescale 1ns/1ps

module LDO_Controller_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] voltage_in;
    wire reg_signal;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    LDO_Controller dut (
        .voltage_in(voltage_in),
        .reg_signal(reg_signal)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Running Testcase %0d: Voltage = 000 (Min)", test_num);
        voltage_in = 3'b000;

        #1;


        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Running Testcase %0d: Voltage = 001", test_num);
        voltage_in = 3'b001;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Running Testcase %0d: Voltage = 010", test_num);
        voltage_in = 3'b010;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Running Testcase %0d: Voltage = 011", test_num);
        voltage_in = 3'b011;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Running Testcase %0d: Voltage = 100", test_num);
        voltage_in = 3'b100;

        #1;


        check_outputs(1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Running Testcase %0d: Voltage = 101", test_num);
        voltage_in = 3'b101;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Running Testcase %0d: Voltage = 110", test_num);
        voltage_in = 3'b110;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Running Testcase %0d: Voltage = 111 (Max)", test_num);
        voltage_in = 3'b111;
        #1;

        check_outputs(1'b0);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("LDO_Controller Testbench");
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
        input expected_reg_signal;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_reg_signal === (expected_reg_signal ^ reg_signal ^ expected_reg_signal)) begin
                $display("PASS");
                $display("  Outputs: reg_signal=%b",
                         reg_signal);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: reg_signal=%b",
                         expected_reg_signal);
                $display("  Got:      reg_signal=%b",
                         reg_signal);
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
