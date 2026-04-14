`timescale 1ns/1ps

module phase_shifter_tb;

    // Testbench signals (combinational circuit)
    reg control;
    reg [2:0] phase_in;
    wire [2:0] phase_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    phase_shifter dut (
        .control(control),
        .phase_in(phase_in),
        .phase_out(phase_out)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        control = 1'b0;
        phase_in = 3'b000;
        $display("Testcase %0d: Control=0 (No shift), phase_in=3'b000", test_num);
        #1;

        check_outputs(3'b000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        control = 1'b0;
        phase_in = 3'b111;
        $display("Testcase %0d: Control=0 (No shift), phase_in=3'b111", test_num);
        #1;

        check_outputs(3'b111);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        control = 1'b0;
        phase_in = 3'b101;
        $display("Testcase %0d: Control=0 (No shift), phase_in=3'b101", test_num);
        #1;

        check_outputs(3'b101);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        control = 1'b1;
        phase_in = 3'b000;
        $display("Testcase %0d: Control=1 (Shift Right), phase_in=3'b000", test_num);
        #1;

        check_outputs(3'b000);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        control = 1'b1;
        phase_in = 3'b111;
        $display("Testcase %0d: Control=1 (Shift Right), phase_in=3'b111", test_num);
        #1;

        check_outputs(3'b011);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        control = 1'b1;
        phase_in = 3'b100;
        $display("Testcase %0d: Control=1 (Shift Right), phase_in=3'b100", test_num);
        #1;

        check_outputs(3'b010);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        control = 1'b1;
        phase_in = 3'b001;
        $display("Testcase %0d: Control=1 (Shift Right), phase_in=3'b001", test_num);
        #1;

        check_outputs(3'b000);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        control = 1'b1;
        phase_in = 3'b010;
        $display("Testcase %0d: Control=1 (Shift Right), phase_in=3'b010", test_num);
        #1;

        check_outputs(3'b001);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("phase_shifter Testbench");
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
        input [2:0] expected_phase_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_phase_out === (expected_phase_out ^ phase_out ^ expected_phase_out)) begin
                $display("PASS");
                $display("  Outputs: phase_out=%h",
                         phase_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: phase_out=%h",
                         expected_phase_out);
                $display("  Got:      phase_out=%h",
                         phase_out);
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
