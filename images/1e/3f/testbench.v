`timescale 1ns/1ps

module dot_product_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] A;
    reg [4:0] B;
    wire [9:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dot_product dut (
        .A(A),
        .B(B),
        .result(result)
    );
    task testcase001;

        begin
            $display("Testcase 001: All Zeros");
            test_num = 1;
            A = 5'b00000;
            B = 5'b00000;

            #1;


            check_outputs(10'd0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: All Ones (Maximum Result)");
            test_num = 2;
            A = 5'b11111;
            B = 5'b11111;

            #1;


            check_outputs(10'd5);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: No Overlapping Bits");
            test_num = 3;
            A = 5'b10101;
            B = 5'b01010;

            #1;


            check_outputs(10'd0);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Single Bit Overlap (LSB)");
            test_num = 4;
            A = 5'b00001;
            B = 5'b11111;

            #1;


            check_outputs(10'd1);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Single Bit Overlap (MSB)");
            test_num = 5;
            A = 5'b10000;
            B = 5'b10000;

            #1;


            check_outputs(10'd1);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Partial Overlap (3 bits)");
            test_num = 6;
            A = 5'b11100;
            B = 5'b11111;

            #1;


            check_outputs(10'd3);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Interleaved Bits");
            test_num = 7;
            A = 5'b11011;
            B = 5'b10111;




            #1;





            check_outputs(10'd3);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: B is Zero");
            test_num = 8;
            A = 5'b11111;
            B = 5'b00000;
            #1;

            check_outputs(10'd0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("dot_product Testbench");
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
        input [9:0] expected_result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: result=%h",
                         result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result=%h",
                         expected_result);
                $display("  Got:      result=%h",
                         result);
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
