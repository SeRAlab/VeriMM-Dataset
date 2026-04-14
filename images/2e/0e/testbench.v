`timescale 1ns/1ps

module nearest_neighbor_interpolation_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] x;
    reg [1:0] y;
    wire [7:0] pixel_value;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    nearest_neighbor_interpolation dut (
        .x(x),
        .y(y),
        .pixel_value(pixel_value)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("\nTest Case %0d: Coordinate (0,0)", test_num);
        x = 2'b00;
        y = 2'b00;
        #1;

        check_outputs(8'h11);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("\nTest Case %0d: Coordinate (1,1)", test_num);
        x = 2'b01;
        y = 2'b01;
        #1;

        check_outputs(8'h11);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("\nTest Case %0d: Coordinate (2,0)", test_num);
        x = 2'b10;
        y = 2'b00;
        #1;

        check_outputs(8'h22);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("\nTest Case %0d: Coordinate (3,1)", test_num);
        x = 2'b11;
        y = 2'b01;
        #1;

        check_outputs(8'h22);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("\nTest Case %0d: Coordinate (0,2)", test_num);
        x = 2'b00;
        y = 2'b10;
        #1;

        check_outputs(8'h33);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("\nTest Case %0d: Coordinate (1,3)", test_num);
        x = 2'b01;
        y = 2'b11;
        #1;

        check_outputs(8'h33);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("\nTest Case %0d: Coordinate (2,2)", test_num);
        x = 2'b10;
        y = 2'b10;
        #1;

        check_outputs(8'h44);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("\nTest Case %0d: Coordinate (3,3)", test_num);
        x = 2'b11;
        y = 2'b11;
        #1;

        check_outputs(8'h44);
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
        input [7:0] expected_pixel_value;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_pixel_value === (expected_pixel_value ^ pixel_value ^ expected_pixel_value)) begin
                $display("PASS");
                $display("  Outputs: pixel_value=%h",
                         pixel_value);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pixel_value=%h",
                         expected_pixel_value);
                $display("  Got:      pixel_value=%h",
                         pixel_value);
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
