`timescale 1ns/1ps

module twos_complement_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] num;
    wire [3:0] twos_comp;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    twos_complement dut (
        .num(num),
        .twos_comp(twos_comp)
    );
    task testcase001;

        begin
            $display("Testcase 001: Zero input (0000)");
            num = 4'b0000;
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Positive one (0001)");
            num = 4'b0001;
            #1;

            check_outputs(4'b1111);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Max positive (0111)");
            num = 4'b0111;
            #1;

            check_outputs(4'b1001);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Negative one (1111)");
            num = 4'b1111;
            #1;

            check_outputs(4'b0001);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Most negative (1000)");
            num = 4'b1000;
            #1;

            check_outputs(4'b1000);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Random negative (1010)");
            num = 4'b1010;
            #1;

            check_outputs(4'b0110);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Random positive (0100)");
            num = 4'b0100;
            #1;

            check_outputs(4'b1100);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("twos_complement Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
        input [3:0] expected_twos_comp;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_twos_comp === (expected_twos_comp ^ twos_comp ^ expected_twos_comp)) begin
                $display("PASS");
                $display("  Outputs: twos_comp=%h",
                         twos_comp);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: twos_comp=%h",
                         expected_twos_comp);
                $display("  Got:      twos_comp=%h",
                         twos_comp);
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
