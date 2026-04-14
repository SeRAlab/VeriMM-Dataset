`timescale 1ns/1ps

module phase_shifter_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] phase_in;
    reg [1:0] shift_amount;
    wire [3:0] phase_out;

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
            phase_in = 4'b0000;
            shift_amount = 2'b01;
            $display("Test %0d: All zeros input, shift 1", test_num);
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            phase_in = 4'b1111;
            shift_amount = 2'b10;
            $display("Test %0d: All ones input, shift 2", test_num);
            #1;

            check_outputs(4'b1111);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            phase_in = 4'b1000;
            shift_amount = 2'b00;
            $display("Test %0d: MSB set, shift 0 (Identity)", test_num);
            #1;

            check_outputs(4'b1000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            phase_in = 4'b1000;
            shift_amount = 2'b01;
            $display("Test %0d: MSB set, shift 1 (Wrap to LSB)", test_num);
            #1;

            check_outputs(4'b0001);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            phase_in = 4'b1000;
            shift_amount = 2'b10;
            $display("Test %0d: MSB set, shift 2", test_num);
            #1;

            check_outputs(4'b0010);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            phase_in = 4'b1000;
            shift_amount = 2'b11;
            $display("Test %0d: MSB set, shift 3", test_num);
            #1;

            check_outputs(4'b0100);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            phase_in = 4'b1100;
            shift_amount = 2'b01;
            $display("Test %0d: Pattern 1100, shift 1", test_num);
            #1;

            check_outputs(4'b1001);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            phase_in = 4'b1100;
            shift_amount = 2'b10;
            $display("Test %0d: Pattern 1100, shift 2", test_num);
            #1;

            check_outputs(4'b0011);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            phase_in = 4'b1010;
            shift_amount = 2'b01;
            $display("Test %0d: Alternating pattern, shift 1", test_num);
            #1;

            check_outputs(4'b0101);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            phase_in = 4'b1011;
            shift_amount = 2'b10;
            $display("Test %0d: Pattern 1011, shift 2", test_num);
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
