`timescale 1ns/1ps

module LDO_Regulator_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] control;
    reg [3:0] v_ref;
    wire [3:0] v_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    LDO_Regulator dut (
        .control(control),
        .v_ref(v_ref),
        .v_out(v_out)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Unity Gain Mode (control=00, v_ref=8)", test_num);
        control = 2'b00;
        v_ref = 4'd8;
        #1;

        check_outputs(4'd8);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Half Voltage Mode (control=01, v_ref=12)", test_num);
        control = 2'b01;
        v_ref = 4'd12;
        #1;

        check_outputs(4'd6);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Double Voltage Mode (control=10, v_ref=4)", test_num);
        control = 2'b10;
        v_ref = 4'd4;
        #1;

        check_outputs(4'd8);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Shutdown Mode (control=11, v_ref=15)", test_num);
        control = 2'b11;
        v_ref = 4'd15;
        #1;

        check_outputs(4'd0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Saturation Check (control=10, v_ref=10)", test_num);
        control = 2'b10;
        v_ref = 4'd10;
        #1;

        check_outputs(4'd15);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Zero Reference Check (control=00, v_ref=0)", test_num);
        control = 2'b00;
        v_ref = 4'd0;
        #1;

        check_outputs(4'd0);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("LDO_Regulator Testbench");
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
        input [3:0] expected_v_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_v_out === (expected_v_out ^ v_out ^ expected_v_out)) begin
                $display("PASS");
                $display("  Outputs: v_out=%h",
                         v_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: v_out=%h",
                         expected_v_out);
                $display("  Got:      v_out=%h",
                         v_out);
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
