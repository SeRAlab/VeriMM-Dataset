`timescale 1ns/1ps

module mux8to1_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] D;
    reg [2:0] S;
    wire Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mux8to1 dut (
        .D(D),
        .S(S),
        .Y(Y)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Select D0, D0=0", test_num);
            D = 8'b11111110;
            S = 3'b000;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Select D0, D0=1", test_num);
            D = 8'b00000001;
            S = 3'b000;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Select D1, D1=1", test_num);
            D = 8'b00000010;
            S = 3'b001;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Select D2, D2=0", test_num);
            D = 8'b11111011;
            S = 3'b010;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Select D3, D3=1", test_num);
            D = 8'b00001000;
            S = 3'b011;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Select D4, D4=1", test_num);
            D = 8'b00010000;
            S = 3'b100;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Select D5, D5=0", test_num);
            D = 8'b11011111;
            S = 3'b101;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Select D6, D6=1", test_num);
            D = 8'b01000000;
            S = 3'b110;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Testcase %0d: Select D7, D7=0", test_num);
            D = 8'b01111111;
            S = 3'b111;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Testcase %0d: Select D7, D7=1", test_num);
            D = 8'b10000000;
            S = 3'b111;
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
