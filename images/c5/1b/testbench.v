`timescale 1ns/1ps

module barrel_shift_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] DATA;
    reg [1:0] SHIFT;
    wire [3:0] RESULT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    barrel_shift dut (
        .DATA(DATA),
        .SHIFT(SHIFT),
        .RESULT(RESULT)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: No Shift (DATA=1010, SHIFT=00)", test_num);
            DATA = 4'b1010;
            SHIFT = 2'b00;
            #1;

            check_outputs(4'b1010);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Shift 1 Right (DATA=1010, SHIFT=01)", test_num);
            DATA = 4'b1010;
            SHIFT = 2'b01;
            #1;

            check_outputs(4'b0101);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Shift 2 Right (DATA=1010, SHIFT=10)", test_num);
            DATA = 4'b1010;
            SHIFT = 2'b10;
            #1;

            check_outputs(4'b0010);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Shift 3 Right (DATA=1010, SHIFT=11)", test_num);
            DATA = 4'b1010;
            SHIFT = 2'b11;
            #1;

            check_outputs(4'b0001);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All ones right shift (DATA=1111, SHIFT=10)", test_num);
            DATA = 4'b1111;
            SHIFT = 2'b10;
            #1;

            check_outputs(4'b0011);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Boundary bit right shift (DATA=0001, SHIFT=01)", test_num);
            DATA = 4'b0001;
            SHIFT = 2'b01;
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Zero input check (DATA=0000, SHIFT=11)", test_num);
            DATA = 4'b0000;
            SHIFT = 2'b11;
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: High bit shift (DATA=1000, SHIFT=11)", test_num);
            DATA = 4'b1000;
            SHIFT = 2'b11;
            #1;

            check_outputs(4'b0001);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("barrel_shift Testbench");
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
        input [3:0] expected_RESULT;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_RESULT === (expected_RESULT ^ RESULT ^ expected_RESULT)) begin
                $display("PASS");
                $display("  Outputs: RESULT=%h",
                         RESULT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: RESULT=%h",
                         expected_RESULT);
                $display("  Got:      RESULT=%h",
                         RESULT);
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
