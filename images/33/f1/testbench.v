`timescale 1ns/1ps

module mpc_controller_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] gain;
    reg [9:0] pv;
    reg [9:0] ref;
    wire [9:0] control;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mpc_controller dut (
        .gain(gain),
        .pv(pv),
        .ref(ref),
        .control(control)
    );
    task testcase001;

    begin
        $display("\nRunning Testcase 001: Basic positive difference");
        test_num = test_num + 1;
        gain = 4'd2;
        ref = 10'd100;
        pv = 10'd50;

        #1;


        check_outputs(10'd100);
    end
        endtask

    task testcase002;

    begin
        $display("\nRunning Testcase 002: Zero gain");
        test_num = test_num + 1;
        gain = 4'd0;
        ref = 10'd500;
        pv = 10'd100;

        #1;


        check_outputs(10'd0);
    end
        endtask

    task testcase003;

    begin
        $display("\nRunning Testcase 003: Zero difference (Ref == PV)");
        test_num = test_num + 1;
        gain = 4'd15;
        ref = 10'd256;
        pv = 10'd256;

        #1;


        check_outputs(10'd0);
    end
        endtask

    task testcase004;

    begin
        $display("\nRunning Testcase 004: Negative difference");
        test_num = test_num + 1;
        gain = 4'd2;
        ref = 10'd40;
        pv = 10'd50;


        #1;



        check_outputs(10'h3EC);
    end
        endtask

    task testcase005;

    begin
        $display("\nRunning Testcase 005: Maximum gain (15)");
        test_num = test_num + 1;
        gain = 4'd15;
        ref = 10'd10;
        pv = 10'd0;

        #1;


        check_outputs(10'd150);
    end
        endtask

    task testcase006;

    begin
        $display("\nRunning Testcase 006: Output bit truncation");
        test_num = test_num + 1;
        gain = 4'd12;
        ref = 10'd100;
        pv = 10'd0;



        #1;




        check_outputs(10'd176);
    end
        endtask

    task testcase007;

    begin
        $display("\nRunning Testcase 007: Difference of -1");
        test_num = test_num + 1;
        gain = 4'd1;
        ref = 10'd50;
        pv = 10'd51;


        #1;



        check_outputs(10'h3FF);
    end
        endtask

    task testcase008;

    begin
        $display("\nRunning Testcase 008: Large PV and Ref");
        test_num = test_num + 1;
        gain = 4'd1;
        ref = 10'h3FF;
        pv = 10'h000;

        #1;


        check_outputs(10'h3FF);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("mpc_controller Testbench");
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
        input [9:0] expected_control;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_control === (expected_control ^ control ^ expected_control)) begin
                $display("PASS");
                $display("  Outputs: control=%h",
                         control);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: control=%h",
                         expected_control);
                $display("  Got:      control=%h",
                         control);
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
