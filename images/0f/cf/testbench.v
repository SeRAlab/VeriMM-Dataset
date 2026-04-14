`timescale 1ns/1ps

module RobotMovement_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] direction;
    reg [3:0] x_in;
    reg [3:0] y_in;
    wire [3:0] x_out;
    wire [3:0] y_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    RobotMovement dut (
        .direction(direction),
        .x_in(x_in),
        .y_in(y_in),
        .x_out(x_out),
        .y_out(y_out)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Move North from (5,5)", test_num);
            x_in = 4'd5;
            y_in = 4'd5;
            direction = 2'b00;
            #1;

            check_outputs(4'd5, 4'd6);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Move East from (5,5)", test_num);
            x_in = 4'd5;
            y_in = 4'd5;
            direction = 2'b01;
            #1;

            check_outputs(4'd6, 4'd5);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Move South from (5,5)", test_num);
            x_in = 4'd5;
            y_in = 4'd5;
            direction = 2'b10;
            #1;

            check_outputs(4'd5, 4'd4);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Move West from (5,5)", test_num);
            x_in = 4'd5;
            y_in = 4'd5;
            direction = 2'b11;
            #1;

            check_outputs(4'd4, 4'd5);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Move North boundary (Wrap-around Y)", test_num);
            x_in = 4'd10;
            y_in = 4'd15;
            direction = 2'b00;
            #1;

            check_outputs(4'd10, 4'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Move East boundary (Wrap-around X)", test_num);
            x_in = 4'd15;
            y_in = 4'd10;
            direction = 2'b01;
            #1;

            check_outputs(4'd0, 4'd10);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case %0d: Move South boundary (Wrap-around Y)", test_num);
            x_in = 4'd2;
            y_in = 4'd0;
            direction = 2'b10;
            #1;

            check_outputs(4'd2, 4'd15);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test Case %0d: Move West boundary (Wrap-around X)", test_num);
            x_in = 4'd0;
            y_in = 4'd8;
            direction = 2'b11;
            #1;

            check_outputs(4'd15, 4'd8);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test Case %0d: Move North from origin", test_num);
            x_in = 4'd0;
            y_in = 4'd0;
            direction = 2'b00;
            #1;

            check_outputs(4'd0, 4'd1);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Test Case %0d: Move South from (15,15)", test_num);
            x_in = 4'd15;
            y_in = 4'd15;
            direction = 2'b10;
            #1;

            check_outputs(4'd15, 4'd14);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("RobotMovement Testbench");
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
        input [3:0] expected_x_out;
        input [3:0] expected_y_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_x_out === (expected_x_out ^ x_out ^ expected_x_out) &&
                expected_y_out === (expected_y_out ^ y_out ^ expected_y_out)) begin
                $display("PASS");
                $display("  Outputs: x_out=%h, y_out=%h",
                         x_out, y_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: x_out=%h, y_out=%h",
                         expected_x_out, expected_y_out);
                $display("  Got:      x_out=%h, y_out=%h",
                         x_out, y_out);
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
