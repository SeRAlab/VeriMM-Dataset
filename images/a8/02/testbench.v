`timescale 1ns/1ps

module seven_segment_decoder_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] bin_input;
    wire [6:0] seg_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    seven_segment_decoder dut (
        .bin_input(bin_input),
        .seg_output(seg_output)
    );
    task testcase001;

        begin
            $display("Test Case 001: Input 0");
            bin_input = 4'h0;
            #1;

            check_outputs(7'b0111111);
        end
        endtask

    task testcase002;

        begin
            $display("Test Case 002: Input 1");
            bin_input = 4'h1;
            #1;

            check_outputs(7'b0000110);
        end
        endtask

    task testcase003;

        begin
            $display("Test Case 003: Input 2");
            bin_input = 4'h2;
            #1;

            check_outputs(7'b1011011);
        end
        endtask

    task testcase004;

        begin
            $display("Test Case 004: Input 3");
            bin_input = 4'h3;
            #1;

            check_outputs(7'b1001111);
        end
        endtask

    task testcase005;

        begin
            $display("Test Case 005: Input 4");
            bin_input = 4'h4;
            #1;

            check_outputs(7'b1100110);
        end
        endtask

    task testcase006;

        begin
            $display("Test Case 006: Input 5");
            bin_input = 4'h5;
            #1;

            check_outputs(7'b1101101);
        end
        endtask

    task testcase007;

        begin
            $display("Test Case 007: Input 6");
            bin_input = 4'h6;
            #1;

            check_outputs(7'b1111101);
        end
        endtask

    task testcase008;

        begin
            $display("Test Case 008: Input 7");
            bin_input = 4'h7;
            #1;

            check_outputs(7'b0000111);
        end
        endtask

    task testcase009;

        begin
            $display("Test Case 009: Input 8");
            bin_input = 4'h8;
            #1;

            check_outputs(7'b1111111);
        end
        endtask

    task testcase010;

        begin
            $display("Test Case 010: Input 9");
            bin_input = 4'h9;
            #1;

            check_outputs(7'b1101111);
        end
        endtask

    task testcase011;

        begin
            $display("Test Case 011: Input A");
            bin_input = 4'hA;
            #1;

            check_outputs(7'b1110111);
        end
        endtask

    task testcase012;

        begin
            $display("Test Case 012: Input B");
            bin_input = 4'hB;
            #1;

            check_outputs(7'b1111100);
        end
        endtask

    task testcase013;

        begin
            $display("Test Case 013: Input C");
            bin_input = 4'hC;
            #1;

            check_outputs(7'b0111001);
        end
        endtask

    task testcase014;

        begin
            $display("Test Case 014: Input D");
            bin_input = 4'hD;
            #1;

            check_outputs(7'b1011110);
        end
        endtask

    task testcase015;

        begin
            $display("Test Case 015: Input E");
            bin_input = 4'hE;
            #1;

            check_outputs(7'b1111001);
        end
        endtask

    task testcase016;

        begin
            $display("Test Case 016: Input F");
            bin_input = 4'hF;
            #1;

            check_outputs(7'b1110001);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("seven_segment_decoder Testbench");
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
        input [6:0] expected_seg_output;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_seg_output === (expected_seg_output ^ seg_output ^ expected_seg_output)) begin
                $display("PASS");
                $display("  Outputs: seg_output=%h",
                         seg_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: seg_output=%h",
                         expected_seg_output);
                $display("  Got:      seg_output=%h",
                         seg_output);
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
