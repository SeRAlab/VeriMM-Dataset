`timescale 1ns/1ps

module decoder_3_to_8_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] A;
    wire [7:0] Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    decoder_3_to_8 dut (
        .A(A),
        .Y(Y)
    );
    task testcase001;

        begin
            $display("Test Case 001: A = 000");
            A = 3'b000;
            #1;

            check_outputs(8'h01);
        end
        endtask

    task testcase002;

        begin
            $display("Test Case 002: A = 001");
            A = 3'b001;
            #1;

            check_outputs(8'h02);
        end
        endtask

    task testcase003;

        begin
            $display("Test Case 003: A = 010");
            A = 3'b010;
            #1;

            check_outputs(8'h04);
        end
        endtask

    task testcase004;

        begin
            $display("Test Case 004: A = 011");
            A = 3'b011;
            #1;

            check_outputs(8'h08);
        end
        endtask

    task testcase005;

        begin
            $display("Test Case 005: A = 100");
            A = 3'b100;
            #1;

            check_outputs(8'h10);
        end
        endtask

    task testcase006;

        begin
            $display("Test Case 006: A = 101");
            A = 3'b101;
            #1;

            check_outputs(8'h20);
        end
        endtask

    task testcase007;

        begin
            $display("Test Case 007: A = 110");
            A = 3'b110;
            #1;

            check_outputs(8'h40);
        end
        endtask

    task testcase008;

        begin
            $display("Test Case 008: A = 111");
            A = 3'b111;
            #1;

            check_outputs(8'h80);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("decoder_3_to_8 Testbench");
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
        input [7:0] expected_Y;
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
