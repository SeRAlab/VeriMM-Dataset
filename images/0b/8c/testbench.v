`timescale 1ns/1ps

module decoder_4_to_16_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    wire [15:0] Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    decoder_4_to_16 dut (
        .A(A),
        .Y(Y)
    );
    task testcase001;

        begin
            $display("Test Case 001: Input A = 0 (4'b0000)");
            A = 4'd0;
            #1;

            check_outputs(16'h0001);
        end
        endtask

    task testcase002;

        begin
            $display("Test Case 002: Input A = 1 (4'b0001)");
            A = 4'd1;
            #1;

            check_outputs(16'h0002);
        end
        endtask

    task testcase003;

        begin
            $display("Test Case 003: Input A = 2 (4'b0010)");
            A = 4'd2;
            #1;

            check_outputs(16'h0004);
        end
        endtask

    task testcase004;

        begin
            $display("Test Case 004: Input A = 3 (4'b0011)");
            A = 4'd3;
            #1;

            check_outputs(16'h0008);
        end
        endtask

    task testcase005;

        begin
            $display("Test Case 005: Input A = 4 (4'b0100)");
            A = 4'd4;
            #1;

            check_outputs(16'h0010);
        end
        endtask

    task testcase006;

        begin
            $display("Test Case 006: Input A = 5 (4'b0101)");
            A = 4'd5;
            #1;

            check_outputs(16'h0020);
        end
        endtask

    task testcase007;

        begin
            $display("Test Case 007: Input A = 6 (4'b0110)");
            A = 4'd6;
            #1;

            check_outputs(16'h0040);
        end
        endtask

    task testcase008;

        begin
            $display("Test Case 008: Input A = 7 (4'b0111)");
            A = 4'd7;
            #1;

            check_outputs(16'h0080);
        end
        endtask

    task testcase009;

        begin
            $display("Test Case 009: Input A = 8 (4'b1000)");
            A = 4'd8;
            #1;

            check_outputs(16'h0100);
        end
        endtask

    task testcase010;

        begin
            $display("Test Case 010: Input A = 9 (4'b1001)");
            A = 4'd9;
            #1;

            check_outputs(16'h0200);
        end
        endtask

    task testcase011;

        begin
            $display("Test Case 011: Input A = 10 (4'b1010)");
            A = 4'd10;
            #1;

            check_outputs(16'h0400);
        end
        endtask

    task testcase012;

        begin
            $display("Test Case 012: Input A = 11 (4'b1011)");
            A = 4'd11;
            #1;

            check_outputs(16'h0800);
        end
        endtask

    task testcase013;

        begin
            $display("Test Case 013: Input A = 12 (4'b1100)");
            A = 4'd12;
            #1;

            check_outputs(16'h1000);
        end
        endtask

    task testcase014;

        begin
            $display("Test Case 014: Input A = 13 (4'b1101)");
            A = 4'd13;
            #1;

            check_outputs(16'h2000);
        end
        endtask

    task testcase015;

        begin
            $display("Test Case 015: Input A = 14 (4'b1110)");
            A = 4'd14;
            #1;

            check_outputs(16'h4000);
        end
        endtask

    task testcase016;

        begin
            $display("Test Case 016: Input A = 15 (4'b1111)");
            A = 4'd15;
            #1;

            check_outputs(16'h8000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("decoder_4_to_16 Testbench");
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
        testcase011();
        testcase012();
        testcase013();
        testcase014();
        testcase015();
        testcase016();
        
        
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
        input [15:0] expected_Y;
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
