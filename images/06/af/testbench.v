`timescale 1ns/1ps

module phase_shifter_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] angle;
    wire [3:0] phase_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    phase_shifter dut (
        .angle(angle),
        .phase_output(phase_output)
    );
    task testcase001;

    begin
        test_num = 1;
        angle = 3'b000;
        #10;
        #1;

        check_outputs(4'b0000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        angle = 3'b001;
        #10;
        #1;

        check_outputs(4'b0010);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        angle = 3'b010;
        #10;
        #1;

        check_outputs(4'b0100);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        angle = 3'b011;
        #10;
        #1;

        check_outputs(4'b0110);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        angle = 3'b100;
        #10;
        #1;

        check_outputs(4'b1000);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        angle = 3'b101;
        #10;
        #1;

        check_outputs(4'b1010);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        angle = 3'b110;
        #10;
        #1;

        check_outputs(4'b1100);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        angle = 3'b111;
        #10;
        #1;

        check_outputs(4'b1110);
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
        input [3:0] expected_phase_output;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_phase_output === (expected_phase_output ^ phase_output ^ expected_phase_output)) begin
                $display("PASS");
                $display("  Outputs: phase_output=%h",
                         phase_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: phase_output=%h",
                         expected_phase_output);
                $display("  Got:      phase_output=%h",
                         phase_output);
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
