`timescale 1ns/1ps

module Concatenate_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] IN;
    wire [7:0] OUT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    Concatenate dut (
        .IN(IN),
        .OUT(OUT)
    );
    task testcase001;

        begin
            test_num = 1;
            IN = 4'b0000;
            $display("Test %0d: Input IN = %b", test_num, IN);
            #1;

            check_outputs(8'b00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            IN = 4'b1111;
            $display("Test %0d: Input IN = %b", test_num, IN);
            #1;

            check_outputs(8'b11111111);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            IN = 4'b1010;
            $display("Test %0d: Input IN = %b", test_num, IN);
            #1;

            check_outputs(8'b10101010);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            IN = 4'b0101;
            $display("Test %0d: Input IN = %b", test_num, IN);
            #1;

            check_outputs(8'b01010101);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            IN = 4'b1100;
            $display("Test %0d: Input IN = %b", test_num, IN);
            #1;

            check_outputs(8'b11001100);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            IN = 4'b0011;
            $display("Test %0d: Input IN = %b", test_num, IN);
            #1;

            check_outputs(8'b00110011);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            IN = 4'b1001;
            $display("Test %0d: Input IN = %b", test_num, IN);
            #1;

            check_outputs(8'b10011001);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            IN = 4'b0110;
            $display("Test %0d: Input IN = %b", test_num, IN);
            #1;

            check_outputs(8'b01100110);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("Concatenate Testbench");
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
        input [7:0] expected_OUT;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_OUT === (expected_OUT ^ OUT ^ expected_OUT)) begin
                $display("PASS");
                $display("  Outputs: OUT=%h",
                         OUT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: OUT=%h",
                         expected_OUT);
                $display("  Got:      OUT=%h",
                         OUT);
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
