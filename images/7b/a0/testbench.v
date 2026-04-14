`timescale 1ns/1ps

module binary_to_gray_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] BIN;
    wire [3:0] GRAY;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    binary_to_gray dut (
        .BIN(BIN),
        .GRAY(GRAY)
    );
    task testcase001;

        begin
            test_num = 1;
            BIN = 4'b0000;
            #10;
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            BIN = 4'b0001;
            #10;
            #1;

            check_outputs(4'b0001);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            BIN = 4'b0010;
            #10;
            #1;

            check_outputs(4'b0011);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            BIN = 4'b0100;
            #10;
            #1;

            check_outputs(4'b0110);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            BIN = 4'b0111;
            #10;
            #1;

            check_outputs(4'b0100);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            BIN = 4'b1000;
            #10;
            #1;

            check_outputs(4'b1100);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            BIN = 4'b1010;
            #10;
            #1;

            check_outputs(4'b1111);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            BIN = 4'b1111;
            #10;
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
        $display("binary_to_gray Testbench");
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
        input [3:0] expected_GRAY;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_GRAY === (expected_GRAY ^ GRAY ^ expected_GRAY)) begin
                $display("PASS");
                $display("  Outputs: GRAY=%h",
                         GRAY);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: GRAY=%h",
                         expected_GRAY);
                $display("  Got:      GRAY=%h",
                         GRAY);
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
