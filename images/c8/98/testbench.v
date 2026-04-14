`timescale 1ns/1ps

module mult_by_3_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] x;
    wire [5:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mult_by_3 dut (
        .x(x),
        .y(y)
    );
    task testcase001;

        begin
            x = 4'd0;
            #1;

            check_outputs(6'd0);
        end
        endtask

    task testcase002;

        begin
            x = 4'd1;
            #1;

            check_outputs(6'd3);
        end
        endtask

    task testcase003;

        begin
            x = 4'd2;
            #1;

            check_outputs(6'd6);
        end
        endtask

    task testcase004;

        begin
            x = 4'd4;
            #1;

            check_outputs(6'd12);
        end
        endtask

    task testcase005;

        begin
            x = 4'd5;
            #1;

            check_outputs(6'd15);
        end
        endtask

    task testcase006;

        begin
            x = 4'd8;
            #1;

            check_outputs(6'd24);
        end
        endtask

    task testcase007;

        begin
            x = 4'd10;
            #1;

            check_outputs(6'd30);
        end
        endtask

    task testcase008;

        begin
            x = 4'd12;
            #1;

            check_outputs(6'd36);
        end
        endtask

    task testcase009;

        begin
            x = 4'd14;
            #1;

            check_outputs(6'd42);
        end
        endtask

    task testcase010;

        begin
            x = 4'd15;
            #1;

            check_outputs(6'd45);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("mult_by_3 Testbench");
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
        input [5:0] expected_y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: y=%h",
                         y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: y=%h",
                         expected_y);
                $display("  Got:      y=%h",
                         y);
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
