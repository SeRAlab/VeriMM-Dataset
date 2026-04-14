`timescale 1ns/1ps

module encoder_16_to_4_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] I;
    wire V;
    wire [3:0] Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    encoder_16_to_4 dut (
        .I(I),
        .V(V),
        .Y(Y)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: No inputs active", test_num);
            I = 16'h0000;
            #1;

            check_outputs(1'b0, 4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Only I0 active", test_num);
            I = 16'h0001;
            #1;

            check_outputs(1'b1, 4'h0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Only I15 active", test_num);
            I = 16'h8000;
            #1;

            check_outputs(1'b1, 4'hF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: I15 and others active (Priority check)", test_num);
            I = 16'h8001;
            #1;

            check_outputs(1'b1, 4'hF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: I7 and I3 active (Priority check)", test_num);
            I = 16'h0088;
            #1;

            check_outputs(1'b1, 4'h7);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: All inputs active", test_num);
            I = 16'hFFFF;
            #1;

            check_outputs(1'b1, 4'hF);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Only I8 active", test_num);
            I = 16'h0100;
            #1;

            check_outputs(1'b1, 4'h8);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: I10 and I9 active", test_num);
            I = 16'h0600;
            #1;

            check_outputs(1'b1, 4'hA);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Only I4 active", test_num);
            I = 16'h0010;
            #1;

            check_outputs(1'b1, 4'h4);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Only I1 active", test_num);
            I = 16'h0002;
            #1;

            check_outputs(1'b1, 4'h1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("encoder_16_to_4 Testbench");
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
        input [3:0] expected_Y;
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
