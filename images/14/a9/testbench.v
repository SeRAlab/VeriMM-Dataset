`timescale 1ns/1ps

module digital_phase_shifter_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] control;
    reg [3:0] phase_in;
    wire [3:0] phase_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    digital_phase_shifter dut (
        .control(control),
        .phase_in(phase_in),
        .phase_out(phase_out)
    );
    task testcase001;

    begin
        test_num = 1;
        control = 2'b00;
        phase_in = 4'b0000;
        $display("Test %0d: Control=0 (No shift), phase_in=0", test_num);
        #1;

        check_outputs(4'b0000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        control = 2'b00;
        phase_in = 4'b1011;
        $display("Test %0d: Control=0 (No shift), phase_in=B", test_num);
        #1;

        check_outputs(4'b1011);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        control = 2'b01;
        phase_in = 4'b0001;
        $display("Test %0d: Control=1 (Shift 1), phase_in=1", test_num);
        #1;

        check_outputs(4'b0010);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        control = 2'b01;
        phase_in = 4'b1000;
        $display("Test %0d: Control=1 (Shift 1, Wrap), phase_in=8", test_num);
        #1;

        check_outputs(4'b0001);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        control = 2'b10;
        phase_in = 4'b0011;
        $display("Test %0d: Control=2 (Shift 2), phase_in=3", test_num);
        #1;

        check_outputs(4'b1100);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        control = 2'b10;
        phase_in = 4'b1010;
        $display("Test %0d: Control=2 (Shift 2, Wrap), phase_in=A", test_num);
        #1;

        check_outputs(4'b1010);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        control = 2'b11;
        phase_in = 4'b0001;
        $display("Test %0d: Control=3 (Shift 3), phase_in=1", test_num);
        #1;

        check_outputs(4'b1000);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        control = 2'b11;
        phase_in = 4'b0111;
        $display("Test %0d: Control=3 (Shift 3, Wrap), phase_in=7", test_num);
        #1;

        check_outputs(4'b1011);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        control = 2'b01;
        phase_in = 4'b1111;
        $display("Test %0d: Control=1 (Shift 1), phase_in=F", test_num);
        #1;

        check_outputs(4'b1111);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        control = 2'b10;
        phase_in = 4'b1100;
        $display("Test %0d: Control=2 (Shift 2, Wrap), phase_in=C", test_num);
        #1;

        check_outputs(4'b0011);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("digital_phase_shifter Testbench");
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
        testcase010();
        
        
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
        input [3:0] expected_phase_out;
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
