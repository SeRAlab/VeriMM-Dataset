`timescale 1ns/1ps

module priority_encoder_tb;

    // Testbench signals (combinational circuit)
    reg EN;
    reg [7:0] I;
    wire [2:0] Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    priority_encoder dut (
        .EN(EN),
        .I(I),
        .Y(Y)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            EN = 0;
            I = 8'b11111111;
            $display("Test Case %0d: EN=0, All Inputs High (Should output 0)", test_num);
            #1;

            check_outputs(3'b000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            EN = 1;
            I = 8'b00000000;
            $display("Test Case %0d: EN=1, No Inputs Active (Should output 0)", test_num);
            #1;

            check_outputs(3'b000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            EN = 1;
            I = 8'b00000001;
            $display("Test Case %0d: EN=1, I0 Active", test_num);
            #1;

            check_outputs(3'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            EN = 1;
            I = 8'b00000100;
            $display("Test Case %0d: EN=1, I2 Active", test_num);
            #1;

            check_outputs(3'd2);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            EN = 1;
            I = 8'b10000000;
            $display("Test Case %0d: EN=1, I7 Active", test_num);
            #1;

            check_outputs(3'd7);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            EN = 1;
            I = 8'b10000001;
            $display("Test Case %0d: EN=1, Priority Check (I7 and I0) - Should output 7", test_num);
            #1;

            check_outputs(3'd7);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            EN = 1;
            I = 8'b00101010;
            $display("Test Case %0d: EN=1, Priority Check (I5, I3, I1) - Should output 5", test_num);
            #1;

            check_outputs(3'd5);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            EN = 1;
            I = 8'b01100000;
            $display("Test Case %0d: EN=1, Priority Check (I6, I5) - Should output 6", test_num);
            #1;

            check_outputs(3'd6);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            EN = 1;
            I = 8'b11111111;
            $display("Test Case %0d: EN=1, All Inputs Active - Should output 7", test_num);
            #1;

            check_outputs(3'd7);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            EN = 0;
            I = 8'b00001000;
            $display("Test Case %0d: EN=0, I3 Active (Should output 0)", test_num);
            #1;

            check_outputs(3'b000);
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
