`timescale 1ns/1ps

module encoder_8to3_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] I;
    wire [2:0] Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    encoder_8to3 dut (
        .I(I),
        .Y(Y)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: No inputs active", test_num);
            I = 8'b0000_0000;
            #1;

            check_outputs(3'b000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Input I0 active (Lowest priority)", test_num);
            I = 8'b0000_0001;
            #1;

            check_outputs(3'b000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Input I1 active", test_num);
            I = 8'b0000_0010;
            #1;

            check_outputs(3'b001);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Input I4 active", test_num);
            I = 8'b0001_0000;
            #1;

            check_outputs(3'b100);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Input I7 active (Highest priority)", test_num);
            I = 8'b1000_0000;
            #1;

            check_outputs(3'b111);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Multiple inputs (I7, I0), I7 should win", test_num);
            I = 8'b1000_0001;
            #1;

            check_outputs(3'b111);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Multiple inputs (I3, I2, I1), I3 should win", test_num);
            I = 8'b0000_1110;
            #1;

            check_outputs(3'b011);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Multiple inputs (I5, I4, I0), I5 should win", test_num);
            I = 8'b0011_0001;
            #1;

            check_outputs(3'b101);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Testcase %0d: Multiple inputs (I6, I4, I2), I6 should win", test_num);
            I = 8'b0101_0100;
            #1;

            check_outputs(3'b110);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Testcase %0d: All inputs active, I7 should win", test_num);
            I = 8'b1111_1111;
            #1;

            check_outputs(3'b111);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("encoder_8to3 Testbench");
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
