`timescale 1ns/1ps

module xnor_5bit_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] A;
    reg [4:0] B;
    wire [4:0] Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    xnor_5bit dut (
        .A(A),
        .B(B),
        .Y(Y)
    );
    task testcase001;

        begin
            $display("Testcase 001: All zeros");
            A = 5'b00000;
            B = 5'b00000;
            #1;

            check_outputs(5'b11111);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: All ones");
            A = 5'b11111;
            B = 5'b11111;
            #1;

            check_outputs(5'b11111);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Complementary inputs");
            A = 5'b10101;
            B = 5'b01010;
            #1;

            check_outputs(5'b00000);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Mixed matching and non-matching bits");
            A = 5'b11001;
            B = 5'b10101;







            #1;








            check_outputs(5'b10011);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Single bit difference");
            A = 5'b00000;
            B = 5'b00001;
            #1;

            check_outputs(5'b11110);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Max vs Min");
            A = 5'b11111;
            B = 5'b00000;
            #1;

            check_outputs(5'b00000);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Walking ones");
            A = 5'b00010;
            B = 5'b00010;
            #1;

            check_outputs(5'b11111);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("xnor_5bit Testbench");
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
        input [4:0] expected_Y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Y === (expected_Y ^ Y ^ expected_Y)) begin
                $display("PASS");
                $display("  Outputs: Y=%h",
                         Y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Y=%h",
                         expected_Y);
                $display("  Got:      Y=%h",
                         Y);
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
