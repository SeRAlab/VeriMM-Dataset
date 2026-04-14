`timescale 1ns/1ps

module nearest_neighbor_interpolation_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] x1;
    reg [7:0] x2;
    reg [7:0] y1;
    reg [7:0] y2;
    wire [7:0] output_pixel;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    nearest_neighbor_interpolation dut (
        .x1(x1),
        .x2(x2),
        .y1(y1),
        .y2(y2),
        .output_pixel(output_pixel)
    );
    task testcase001;

    begin
        test_num = 1;
        x1 = 8'hAA;
        x2 = 8'h55;
        y1 = 8'h00;
        y2 = 8'h00;
        $display("Testcase 001: Target at Origin (0,0)");
        #1;

        check_outputs(8'hAA);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        x1 = 8'hAA;
        x2 = 8'h55;
        y1 = 8'hFF;
        y2 = 8'hFF;
        $display("Testcase 002: Target at Far Corner (255,255)");
        #1;

        check_outputs(8'h55);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        x1 = 8'h10;
        x2 = 8'hF0;
        y1 = 8'h40;
        y2 = 8'h40;
        $display("Testcase 003: Target in Quadrant 1");
        #1;

        check_outputs(8'h10);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        x1 = 8'h10;
        x2 = 8'hF0;
        y1 = 8'hC0;
        y2 = 8'hC0;
        $display("Testcase 004: Target in Quadrant 4");
        #1;

        check_outputs(8'hF0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        x1 = 8'hDE;
        x2 = 8'hAD;
        y1 = 8'h7F;
        y2 = 8'h7F;
        $display("Testcase 005: Boundary check (Midpoint Low)");
        #1;

        check_outputs(8'hDE);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        x1 = 8'hDE;
        x2 = 8'hAD;
        y1 = 8'h80;
        y2 = 8'h80;
        $display("Testcase 006: Boundary check (Midpoint High)");
        #1;

        check_outputs(8'hAD);
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
        input [7:0] expected_output_pixel;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_output_pixel === (expected_output_pixel ^ output_pixel ^ expected_output_pixel)) begin
                $display("PASS");
                $display("  Outputs: output_pixel=%h",
                         output_pixel);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: output_pixel=%h",
                         expected_output_pixel);
                $display("  Got:      output_pixel=%h",
                         output_pixel);
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
