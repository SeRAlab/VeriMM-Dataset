`timescale 1ns/1ps

module phase_shifter_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] phase_in;
    reg [1:0] shift_amount;
    wire [2:0] phase_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    phase_shifter dut (
        .phase_in(phase_in),
        .shift_amount(shift_amount),
        .phase_out(phase_out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: No shift (shift_amount=0)", test_num);
            phase_in = 3'b011;
            shift_amount = 2'b00;
            #1;

            check_outputs(3'b011);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Shift by 1", test_num);
            phase_in = 3'b101;
            shift_amount = 2'b01;
            #1;

            check_outputs(3'b110);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Shift by 2 (No Wrap)", test_num);
            phase_in = 3'b010;
            shift_amount = 2'b10;
            #1;

            check_outputs(3'b100);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Shift by 3 (No Wrap)", test_num);
            phase_in = 3'b001;
            shift_amount = 2'b11;
            #1;

            check_outputs(3'b100);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Wrap around with shift 1", test_num);
            phase_in = 3'b111;
            shift_amount = 2'b01;
            #1;

            check_outputs(3'b000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Wrap around with shift 2", test_num);
            phase_in = 3'b111;
            shift_amount = 2'b10;
            #1;

            check_outputs(3'b001);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Wrap around with shift 3", test_num);
            phase_in = 3'b110;
            shift_amount = 2'b11;
            #1;

            check_outputs(3'b001);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Max input, max shift wrap around", test_num);
            phase_in = 3'b111;
            shift_amount = 2'b11;
            #1;

            check_outputs(3'b010);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Zero input, zero shift", test_num);
            phase_in = 3'b000;
            shift_amount = 2'b00;
            #1;

            check_outputs(3'b000);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Zero input, max shift", test_num);
            phase_in = 3'b000;
            shift_amount = 2'b11;
            #1;

            check_outputs(3'b011);
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
