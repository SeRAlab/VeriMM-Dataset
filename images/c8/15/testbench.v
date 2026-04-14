`timescale 1ns/1ps

module twos_complement_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] a;
    wire [3:0] twos_comp;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    twos_complement dut (
        .a(a),
        .twos_comp(twos_comp)
    );
    task testcase001;

        begin
            $display("Testcase 001: Input 0000 (Zero)");
            test_num = test_num + 1;
            a = 4'b0000;
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Input 0001 (Decimal 1)");
            test_num = test_num + 1;
            a = 4'b0001;
            #1;

            check_outputs(4'b1111);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Input 0111 (Decimal 7 - Max Positive)");
            test_num = test_num + 1;
            a = 4'b0111;
            #1;

            check_outputs(4'b1001);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Input 1000 (Decimal -8 - Max Negative)");
            test_num = test_num + 1;
            a = 4'b1000;
            #1;

            check_outputs(4'b1000);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Input 1111 (Decimal -1)");
            test_num = test_num + 1;
            a = 4'b1111;
            #1;

            check_outputs(4'b0001);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Input 1100 (Decimal -4)");
            test_num = test_num + 1;
            a = 4'b1100;
            #1;

            check_outputs(4'b0100);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Input 0100 (Decimal 4)");
            test_num = test_num + 1;
            a = 4'b0100;
            #1;

            check_outputs(4'b1100);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: Input 1010 (Decimal -6)");
            test_num = test_num + 1;
            a = 4'b1010;
            #1;

            check_outputs(4'b0110);
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
