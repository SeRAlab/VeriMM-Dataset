`timescale 1ns/1ps

module priority_encoder_4to2_tb;

    // Testbench signals (combinational circuit)
    reg I0;
    reg I1;
    reg I2;
    reg I3;
    wire V;
    wire [1:0] Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    priority_encoder_4to2 dut (
        .I0(I0),
        .I1(I1),
        .I2(I2),
        .I3(I3),
        .V(V),
        .Y(Y)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: No inputs active (I=0000)", test_num);
            I3 = 0; I2 = 0; I1 = 0; I0 = 0;
            #1;

            check_outputs(1'b0, 2'b00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input I0 active (I=0001)", test_num);
            I3 = 0; I2 = 0; I1 = 0; I0 = 1;
            #1;

            check_outputs(1'b1, 2'b00);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input I1 active (I=0010)", test_num);
            I3 = 0; I2 = 0; I1 = 1; I0 = 0;
            #1;

            check_outputs(1'b1, 2'b01);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input I2 active (I=0100)", test_num);
            I3 = 0; I2 = 1; I1 = 0; I0 = 0;
            #1;

            check_outputs(1'b1, 2'b10);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input I3 active (I=1000)", test_num);
            I3 = 1; I2 = 0; I1 = 0; I0 = 0;
            #1;

            check_outputs(1'b1, 2'b11);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Priority Check - I3 and I0 active (I=1001)", test_num);
            I3 = 1; I2 = 0; I1 = 0; I0 = 1;
            #1;

            check_outputs(1'b1, 2'b11);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Priority Check - I2 and I1 active (I=0110)", test_num);
            I3 = 0; I2 = 1; I1 = 1; I0 = 0;
            #1;

            check_outputs(1'b1, 2'b10);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Priority Check - I1 and I0 active (I=0011)", test_num);
            I3 = 0; I2 = 0; I1 = 1; I0 = 1;
            #1;

            check_outputs(1'b1, 2'b01);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All inputs active (I=1111)", test_num);
            I3 = 1; I2 = 1; I1 = 1; I0 = 1;
            #1;

            check_outputs(1'b1, 2'b11);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Priority Check - I3, I2, I1 active (I=1110)", test_num);
            I3 = 1; I2 = 1; I1 = 1; I0 = 0;
            #1;

            check_outputs(1'b1, 2'b11);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("priority_encoder_4to2 Testbench");
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
        input expected_V;
        input [1:0] expected_Y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_V === (expected_V ^ V ^ expected_V) &&
                expected_Y === (expected_Y ^ Y ^ expected_Y)) begin
                $display("PASS");
                $display("  Outputs: V=%b, Y=%h",
                         V, Y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: V=%b, Y=%h",
                         expected_V, expected_Y);
                $display("  Got:      V=%b, Y=%h",
                         V, Y);
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
