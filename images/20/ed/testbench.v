`timescale 1ns/1ps

module cordic_rotation_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] angle;
    reg [3:0] x_in;
    reg [3:0] y_in;
    wire [3:0] x_out;
    wire [3:0] y_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    cordic_rotation dut (
        .angle(angle),
        .x_in(x_in),
        .y_in(y_in),
        .x_out(x_out),
        .y_out(y_out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Identity Rotation (Angle 0) - Input (2, 0)", test_num);
            angle = 4'd0;
            x_in  = 4'd2;
            y_in  = 4'd0;

            #1;


            check_outputs(4'd2, 4'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Zero Vector Input - Angle 5", test_num);
            angle = 4'd5;
            x_in  = 4'd0;
            y_in  = 4'd0;

            #1;


            check_outputs(4'd0, 4'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: 90 Degree Rotation - Input (1, 0)", test_num);
            angle = 4'd4;
            x_in  = 4'd1;
            y_in  = 4'd0;

            #1;


            check_outputs(4'd0, 4'd1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: 180 Degree Rotation - Input (3, 0)", test_num);
            angle = 4'd8;
            x_in  = 4'd3;
            y_in  = 4'd0;

            #1;


            check_outputs(4'hD, 4'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: 270 Degree Rotation - Input (0, 2)", test_num);
            angle = 4'd12;
            x_in  = 4'd0;
            y_in  = 4'd2;



            #1;




            check_outputs(4'd2, 4'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Negative Input Rotation - Angle 0", test_num);
            angle = 4'd0;
            x_in  = 4'hF;
            y_in  = 4'hE;

            #1;


            check_outputs(4'hF, 4'hE);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: 90 Degree Rotation - Input (-1, 0)", test_num);
            angle = 4'd4;
            x_in  = 4'hF;
            y_in  = 4'd0;

            #1;


            check_outputs(4'd0, 4'hF);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("cordic_rotation Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
