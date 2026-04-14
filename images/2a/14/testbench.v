`timescale 1ns/1ps

module priority_encoder_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] I;
    wire [1:0] O;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    priority_encoder dut (
        .I(I),
        .O(O)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: No inputs active (0000)", test_num);
            I = 4'b0000;
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Input I0 active (0001)", test_num);
            I = 4'b0001;
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Input I1 active (0010)", test_num);
            I = 4'b0010;
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Input I2 active (0100)", test_num);
            I = 4'b0100;
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Input I3 active (1000)", test_num);
            I = 4'b1000;
            #1;

            check_outputs(2'b11);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Multiple inputs (1011), I3 priority", test_num);
            I = 4'b1011;
            #1;

            check_outputs(2'b11);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Multiple inputs (1111), I3 priority", test_num);
            I = 4'b1111;
            #1;

            check_outputs(2'b11);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: Multiple inputs (0110), I2 priority", test_num);
            I = 4'b0110;
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test %0d: Multiple inputs (0101), I2 priority", test_num);
            I = 4'b0101;
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Test %0d: Multiple inputs (0011), I1 priority", test_num);
            I = 4'b0011;
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase011;

        begin
            test_num = 11;
            $display("Test %0d: Sparse inputs (1010), I3 priority", test_num);
            I = 4'b1010;
            #1;

            check_outputs(2'b11);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("priority_encoder Testbench");
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
        input [1:0] expected_O;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_O === (expected_O ^ O ^ expected_O)) begin
                $display("PASS");
                $display("  Outputs: O=%h",
                         O);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: O=%h",
                         expected_O);
                $display("  Got:      O=%h",
                         O);
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
