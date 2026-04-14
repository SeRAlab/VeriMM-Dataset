`timescale 1ns/1ps

module encoder_8_to_3_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] I;
    wire [2:0] Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    encoder_8_to_3 dut (
        .I(I),
        .Y(Y)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: No inputs high", test_num);
            I = 8'b0000_0000;
            #1;

            check_outputs(3'b111);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Input I0 high", test_num);
            I = 8'b0000_0001;
            #1;

            check_outputs(3'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Input I1 high", test_num);
            I = 8'b0000_0010;
            #1;

            check_outputs(3'd1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Input I2 high", test_num);
            I = 8'b0000_0100;
            #1;

            check_outputs(3'd2);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Input I3 high", test_num);
            I = 8'b0000_1000;
            #1;

            check_outputs(3'd3);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Input I4 high", test_num);
            I = 8'b0001_0000;
            #1;

            check_outputs(3'd4);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case %0d: Input I5 high", test_num);
            I = 8'b0010_0000;
            #1;

            check_outputs(3'd5);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test Case %0d: Input I6 high", test_num);
            I = 8'b0100_0000;
            #1;

            check_outputs(3'd6);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test Case %0d: Input I7 high", test_num);
            I = 8'b1000_0000;
            #1;

            check_outputs(3'd7);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Test Case %0d: Multiple inputs (I1 and I0 high)", test_num);
            I = 8'b0000_0011;
            #1;

            check_outputs(3'd1);
        end
        endtask

    task testcase011;

        begin
            test_num = 11;
            $display("Test Case %0d: Multiple inputs (I7, I4, I0 high)", test_num);
            I = 8'b1001_0001;
            #1;

            check_outputs(3'd7);
        end
        endtask

    task testcase012;

        begin
            test_num = 12;
            $display("Test Case %0d: Multiple inputs (I5, I4, I3, I2 high)", test_num);
            I = 8'b0011_1100;
            #1;

            check_outputs(3'd5);
        end
        endtask

    task testcase013;

        begin
            test_num = 13;
            $display("Test Case %0d: All inputs high", test_num);
            I = 8'b1111_1111;
            #1;

            check_outputs(3'd7);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("encoder_8_to_3 Testbench");
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
        input [2:0] expected_Y;
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
