`timescale 1ns/1ps

module priority_encoder_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] I;
    wire EN;
    wire [2:0] Q;
    wire V;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    priority_encoder dut (
        .I(I),
        .EN(EN),
        .Q(Q),
        .V(V)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: No inputs asserted", test_num);
            I = 8'b0000_0000;

            #1;


            check_outputs(1'b0, 3'd0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Single input I0 asserted", test_num);
            I = 8'b0000_0001;

            #1;


            check_outputs(1'b1, 3'd0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Single input I7 asserted", test_num);
            I = 8'b1000_0000;

            #1;


            check_outputs(1'b1, 3'd7, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Single input I3 asserted", test_num);
            I = 8'b0000_1000;

            #1;


            check_outputs(1'b1, 3'd3, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Multiple inputs (I0 and I1)", test_num);
            I = 8'b0000_0011;

            #1;


            check_outputs(1'b1, 3'd1, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Multiple inputs (I0 and I7)", test_num);
            I = 8'b1000_0001;

            #1;


            check_outputs(1'b1, 3'd7, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Three inputs (I2, I4, I5)", test_num);
            I = 8'b0011_0100;

            #1;


            check_outputs(1'b1, 3'd5, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All inputs asserted", test_num);
            I = 8'b1111_1111;

            #1;


            check_outputs(1'b1, 3'd7, 1'b1);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Check middle range (I3, I4)", test_num);
            I = 8'b0001_1000;

            #1;


            check_outputs(1'b1, 3'd4, 1'b1);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Sparse inputs (I1, I6)", test_num);
            I = 8'b0100_0010;

            #1;


            check_outputs(1'b1, 3'd6, 1'b1);
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
        input expected_EN;
        input [2:0] expected_Q;
        input expected_V;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_EN === (expected_EN ^ EN ^ expected_EN) &&
                expected_Q === (expected_Q ^ Q ^ expected_Q) &&
                expected_V === (expected_V ^ V ^ expected_V)) begin
                $display("PASS");
                $display("  Outputs: EN=%b, Q=%h, V=%b",
                         EN, Q, V);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: EN=%b, Q=%h, V=%b",
                         expected_EN, expected_Q, expected_V);
                $display("  Got:      EN=%b, Q=%h, V=%b",
                         EN, Q, V);
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
