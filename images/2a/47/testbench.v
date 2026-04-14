`timescale 1ns/1ps

module mpc_control_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] measured;
    reg [3:0] setpoint;
    wire [3:0] control_signal;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mpc_control dut (
        .measured(measured),
        .setpoint(setpoint),
        .control_signal(control_signal)
    );
    task testcase001;

    begin
        test_num = 1;
        setpoint = 4'b0000;
        measured = 4'b0000;
        $display("Test %0d: Setpoint=0, Measured=0", test_num);
        #1;

        check_outputs(4'b0000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        setpoint = 4'b0101;
        measured = 4'b0010;
        $display("Test %0d: Setpoint=5, Measured=2", test_num);
        #1;

        check_outputs(4'b0011);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        setpoint = 4'b0010;
        measured = 4'b0101;
        $display("Test %0d: Setpoint=2, Measured=5", test_num);
        #1;

        check_outputs(4'b1101);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        setpoint = 4'b0111;
        measured = 4'b0000;
        $display("Test %0d: Setpoint=7, Measured=0", test_num);
        #1;

        check_outputs(4'b0111);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        setpoint = 4'b1000;
        measured = 4'b0000;
        $display("Test %0d: Setpoint=-8, Measured=0", test_num);
        #1;

        check_outputs(4'b1000);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        setpoint = 4'b0111;
        measured = 4'b1110;
        $display("Test %0d: Setpoint=7, Measured=-2 (Diff=9)", test_num);
        #1;

        check_outputs(4'b0111);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        setpoint = 4'b1001;
        measured = 4'b0101;
        $display("Test %0d: Setpoint=-7, Measured=5 (Diff=-12)", test_num);
        #1;

        check_outputs(4'b1000);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        setpoint = 4'b0111;
        measured = 4'b1000;
        $display("Test %0d: Setpoint=7, Measured=-8 (Diff=15)", test_num);
        #1;

        check_outputs(4'b0111);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        setpoint = 4'b1000;
        measured = 4'b0111;
        $display("Test %0d: Setpoint=-8, Measured=7 (Diff=-15)", test_num);
        #1;

        check_outputs(4'b1000);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("mpc_control Testbench");
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
        input [3:0] expected_control_signal;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_control_signal === (expected_control_signal ^ control_signal ^ expected_control_signal)) begin
                $display("PASS");
                $display("  Outputs: control_signal=%h",
                         control_signal);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: control_signal=%h",
                         expected_control_signal);
                $display("  Got:      control_signal=%h",
                         control_signal);
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
