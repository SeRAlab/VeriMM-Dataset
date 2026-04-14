`timescale 1ns/1ps

module nearest_neighbor_interpolation_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] x_in;
    reg [2:0] y_in;
    wire [4:0] color_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    nearest_neighbor_interpolation dut (
        .x_in(x_in),
        .y_in(y_in),
        .color_out(color_out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Coordinate (0,0)", test_num);
            x_in = 3'd0; y_in = 3'd0;
            #1;

            check_outputs(5'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Coordinate (7,7)", test_num);
            x_in = 3'd7; y_in = 3'd7;
            #1;

            check_outputs(5'h1F);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Coordinate (0,7)", test_num);
            x_in = 3'd0; y_in = 3'd7;
            #1;

            check_outputs(5'h03);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Coordinate (7,0)", test_num);
            x_in = 3'd7; y_in = 3'd0;
            #1;

            check_outputs(5'h1C);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Coordinate (3,4)", test_num);
            x_in = 3'd3; y_in = 3'd4;
            #1;

            check_outputs(5'h0E);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Coordinate (1,2)", test_num);
            x_in = 3'd1; y_in = 3'd2;
            #1;

            check_outputs(5'h05);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Coordinate (5,6)", test_num);
            x_in = 3'd5; y_in = 3'd6;
            #1;

            check_outputs(5'h17);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Coordinate (2,5)", test_num);
            x_in = 3'd2; y_in = 3'd5;
            #1;

            check_outputs(5'h0A);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("nearest_neighbor_interpolation Testbench");
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
        input [4:0] expected_color_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_color_out === (expected_color_out ^ color_out ^ expected_color_out)) begin
                $display("PASS");
                $display("  Outputs: color_out=%h",
                         color_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: color_out=%h",
                         expected_color_out);
                $display("  Got:      color_out=%h",
                         color_out);
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
