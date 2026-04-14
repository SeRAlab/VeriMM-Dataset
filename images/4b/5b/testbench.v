`timescale 1ns/1ps

module binary_to_gray_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] binary;
    wire [7:0] gray;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    binary_to_gray dut (
        .binary(binary),
        .gray(gray)
    );
    task testcase001;

        begin
            $display("Testcase 001: Minimum value (Zero)");
            test_num = test_num + 1;
            binary = 8'h00;

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Simple sequence (1-4)");

            test_num = test_num + 1;
            binary = 8'd1;

            #1;


            check_outputs(8'h01);

            test_num = test_num + 1;
            binary = 8'd2;

            #1;


            check_outputs(8'h03);

            test_num = test_num + 1;
            binary = 8'd3;

            #1;


            check_outputs(8'h02);

            test_num = test_num + 1;
            binary = 8'd4;

            #1;


            check_outputs(8'h06);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Boundary values (127, 128)");

            test_num = test_num + 1;
            binary = 8'd127;

            #1;


            check_outputs(8'h40);

            test_num = test_num + 1;
            binary = 8'd128;

            #1;


            check_outputs(8'hC0);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Alternating bit patterns");

            test_num = test_num + 1;
            binary = 8'hAA;

            #1;


            check_outputs(8'hFF);

            test_num = test_num + 1;
            binary = 8'h55;

            #1;


            check_outputs(8'h7F);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Maximum value (255)");
            test_num = test_num + 1;
            binary = 8'hFF;

            #1;


            check_outputs(8'h80);
        end
        endtask

    task testcase006;

        integer i;
        reg [7:0] expected;
        begin
            $display("Testcase 006: Walking one bit (Shifting)");
            for (i = 0; i < 8; i = i + 1) begin
                test_num = test_num + 1;
                binary = (8'b1 << i);
                expected = binary ^ (binary >> 1);
                #1;

                check_outputs(expected);
            end
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
        input [7:0] expected_gray;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_gray === (expected_gray ^ gray ^ expected_gray)) begin
                $display("PASS");
                $display("  Outputs: gray=%h",
                         gray);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: gray=%h",
                         expected_gray);
                $display("  Got:      gray=%h",
                         gray);
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
