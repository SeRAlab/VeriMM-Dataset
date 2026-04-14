`timescale 1ns/1ps

module mux8to1_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] I;
    reg [2:0] S;
    wire Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mux8to1 dut (
        .I(I),
        .S(S),
        .Y(Y)
    );
    task testcase001;

        begin
            test_num = 1;
            I = 8'b00000001; S = 3'b000;
            $display("Testcase %0d: Select I0, Input=1", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            I = 8'b11111110; S = 3'b000;
            $display("Testcase %0d: Select I0, Input=0", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            I = 8'b00000010; S = 3'b001;
            $display("Testcase %0d: Select I1, Input=1", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            I = 8'b11111101; S = 3'b001;
            $display("Testcase %0d: Select I1, Input=0", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            I = 8'b00000100; S = 3'b010;
            $display("Testcase %0d: Select I2, Input=1", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            I = 8'b11111011; S = 3'b010;
            $display("Testcase %0d: Select I2, Input=0", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            I = 8'b00001000; S = 3'b011;
            $display("Testcase %0d: Select I3, Input=1", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            I = 8'b11110111; S = 3'b011;
            $display("Testcase %0d: Select I3, Input=0", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            I = 8'b00010000; S = 3'b100;
            $display("Testcase %0d: Select I4, Input=1", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            I = 8'b11101111; S = 3'b100;
            $display("Testcase %0d: Select I4, Input=0", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase011;

        begin
            test_num = 11;
            I = 8'b00100000; S = 3'b101;
            $display("Testcase %0d: Select I5, Input=1", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase012;

        begin
            test_num = 12;
            I = 8'b11011111; S = 3'b101;
            $display("Testcase %0d: Select I5, Input=0", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase013;

        begin
            test_num = 13;
            I = 8'b01000000; S = 3'b110;
            $display("Testcase %0d: Select I6, Input=1", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase014;

        begin
            test_num = 14;
            I = 8'b10111111; S = 3'b110;
            $display("Testcase %0d: Select I6, Input=0", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase015;

        begin
            test_num = 15;
            I = 8'b10000000; S = 3'b111;
            $display("Testcase %0d: Select I7, Input=1", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase016;

        begin
            test_num = 16;
            I = 8'b01111111; S = 3'b111;
            $display("Testcase %0d: Select I7, Input=0", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase017;

        begin
            test_num = 17;
            I = 8'b10101010; S = 3'b010;
            $display("Testcase %0d: Pattern test, Select I2 (should be 0)", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase018;

        begin
            test_num = 18;
            I = 8'b10101010; S = 3'b111;
            $display("Testcase %0d: Pattern test, Select I7 (should be 1)", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("mux8to1 Testbench");
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
        testcase014();
        testcase015();
        testcase016();
        testcase017();
        testcase018();
        
        
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
        input expected_Y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Y === (expected_Y ^ Y ^ expected_Y)) begin
                $display("PASS");
                $display("  Outputs: Y=%b",
                         Y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Y=%b",
                         expected_Y);
                $display("  Got:      Y=%b",
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
