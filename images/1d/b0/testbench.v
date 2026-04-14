`timescale 1ns/1ps

module bitwise_and_3inputs_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] A;
    reg [4:0] B;
    reg [4:0] C;
    wire [4:0] Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    bitwise_and_3inputs dut (
        .A(A),
        .B(B),
        .C(C),
        .Y(Y)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: All Zeros", test_num);
            A = 5'b00000;
            B = 5'b00000;
            C = 5'b00000;
            #1;

            check_outputs(5'b00000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: All Ones", test_num);
            A = 5'b11111;
            B = 5'b11111;
            C = 5'b11111;
            #1;

            check_outputs(5'b11111);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Partial Overlap (A=11100, B=01110, C=00111)", test_num);
            A = 5'b11100;
            B = 5'b01110;
            C = 5'b00111;


            #1;



            check_outputs(5'b00100);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: One input Zero", test_num);
            A = 5'b11111;
            B = 5'b00000;
            C = 5'b11111;
            #1;

            check_outputs(5'b00000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Alternating Bits", test_num);
            A = 5'b10101;
            B = 5'b10101;
            C = 5'b10101;
            #1;

            check_outputs(5'b10101);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: No Common Bits", test_num);
            A = 5'b10101;
            B = 5'b01010;
            C = 5'b11111;
            #1;

            check_outputs(5'b00000);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case %0d: Single Bit Masking", test_num);
            A = 5'b11111;
            B = 5'b11111;
            C = 5'b00001;
            #1;

            check_outputs(5'b00001);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test Case %0d: Random Bits Pattern 1", test_num);
            A = 5'b11011;
            B = 5'b10111;
            C = 5'b11110;


            #1;



            check_outputs(5'b10010);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test Case %0d: Power of 2 (Bit 4)", test_num);
            A = 5'b10000;
            B = 5'b11000;
            C = 5'b10100;
            #1;

            check_outputs(5'b10000);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Test Case %0d: Walking Ones Mix", test_num);
            A = 5'b00001;
            B = 5'b00011;
            C = 5'b00111;
            #1;

            check_outputs(5'b00001);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("bitwise_and_3inputs Testbench");
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
