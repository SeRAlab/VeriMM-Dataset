`timescale 1ns/1ps

module fsm_ctrl_tb;

    // Testbench signals (combinational circuit)
    reg d;
    reg [2:0] y;
    wire Y2;
    wire Y3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fsm_ctrl dut (
        .d(d),
        .y(y),
        .Y2(Y2),
        .Y3(Y3)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: State D (y=3'b001), d=0 -> Next: State E", test_num);
            y = 3'b001;
            d = 1'b0;

            #1;


            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: State D (y=3'b001), d=1 -> Next: State F", test_num);
            y = 3'b001;
            d = 1'b1;

            #1;


            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: State E (y=3'b010), d=0 -> Next: State F", test_num);
            y = 3'b010;
            d = 1'b0;

            #1;


            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: State E (y=3'b010), d=1 -> Next: State D", test_num);
            y = 3'b010;
            d = 1'b1;

            #1;


            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: State F (y=3'b100), d=0 -> Next: State D", test_num);
            y = 3'b100;
            d = 1'b0;

            #1;


            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: State F (y=3'b100), d=1 -> Next: State E", test_num);
            y = 3'b100;
            d = 1'b1;

            #1;


            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Invalid State Check (y=3'b000), d=0", test_num);
            y = 3'b000;
            d = 1'b0;

            #1;


            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Illegal One-Hot State Check (y=3'b111), d=0", test_num);
            y = 3'b111;
            d = 1'b0;


            #1;



            check_outputs(1'b1, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("fsm_ctrl Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        
        
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
        input expected_Y2;
        input expected_Y3;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Y2 === (expected_Y2 ^ Y2 ^ expected_Y2) &&
                expected_Y3 === (expected_Y3 ^ Y3 ^ expected_Y3)) begin
                $display("PASS");
                $display("  Outputs: Y2=%b, Y3=%b",
                         Y2, Y3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Y2=%b, Y3=%b",
                         expected_Y2, expected_Y3);
                $display("  Got:      Y2=%b, Y3=%b",
                         Y2, Y3);
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
