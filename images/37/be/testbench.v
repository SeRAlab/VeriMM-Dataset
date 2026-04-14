`timescale 1ns/1ps

module decoder_5_to_32_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] A;
    wire [31:0] Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    decoder_5_to_32 dut (
        .A(A),
        .Y(Y)
    );
    task testcase001;

        begin
            $display("Running Test Case 001: Zero value (Input=00000)");
            test_num = test_num + 1;
            A = 5'b00000;
            #1;

            check_outputs(32'h00000001);
        end
        endtask

    task testcase002;

        begin
            $display("Running Test Case 002: Maximum value (Input=11111)");
            test_num = test_num + 1;
            A = 5'b11111;
            #1;

            check_outputs(32'h80000000);
        end
        endtask

    task testcase003;

        begin
            $display("Running Test Case 003: Intermediate value (Input=01111)");
            test_num = test_num + 1;
            A = 5'b01111;
            #1;

            check_outputs(32'h00008000);
        end
        endtask

    task testcase004;

        begin
            $display("Running Test Case 004: Intermediate value (Input=10000)");
            test_num = test_num + 1;
            A = 5'b10000;
            #1;

            check_outputs(32'h00010000);
        end
        endtask

    task testcase005;

        begin
            $display("Running Test Case 005: Alternating bits (Input=01010)");
            test_num = test_num + 1;
            A = 5'b01010;
            #1;

            check_outputs(32'h00000400);
        end
        endtask

    task testcase006;

        begin
            $display("Running Test Case 006: Alternating bits (Input=10101)");
            test_num = test_num + 1;
            A = 5'b10101;
            #1;

            check_outputs(32'h00200000);
        end
        endtask

    task testcase007;

        integer i;
        begin
            $display("Running Test Case 007: Exhaustive Search (0 to 31)");
            for (i = 0; i < 32; i = i + 1) begin
                test_num = test_num + 1;
                A = i;
                #1;

                check_outputs(32'h1 << i);
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
        $display("decoder_5_to_32 Testbench");
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
        input [31:0] expected_Y;
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
