`timescale 1ns/1ps

module nearest_neighbor_interpolation_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] down;
    reg [7:0] left;
    reg [7:0] pixel;
    reg [7:0] right;
    reg [7:0] up;
    wire [7:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    nearest_neighbor_interpolation dut (
        .down(down),
        .left(left),
        .pixel(pixel),
        .right(right),
        .up(up),
        .out(out)
    );
    task testcase001;

    begin
        test_num = 1;
        pixel = 8'hAA; up = 8'h01; down = 8'h02; left = 8'h03; right = 8'h04;
        #1;

        check_outputs(8'hAA);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        pixel = 8'h00; up = 8'hBB; down = 8'h02; left = 8'h03; right = 8'h04;
        #1;

        check_outputs(8'hBB);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        pixel = 8'h00; up = 8'h00; down = 8'hCC; left = 8'h03; right = 8'h04;
        #1;

        check_outputs(8'hCC);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        pixel = 8'h00; up = 8'h00; down = 8'h00; left = 8'hDD; right = 8'h04;
        #1;

        check_outputs(8'hDD);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        pixel = 8'h00; up = 8'h00; down = 8'h00; left = 8'h00; right = 8'hEE;
        #1;

        check_outputs(8'hEE);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        pixel = 8'h00; up = 8'h00; down = 8'h00; left = 8'h00; right = 8'h00;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        pixel = 8'h00; up = 8'h11; down = 8'h00; left = 8'h22; right = 8'h00;
        #1;

        check_outputs(8'h11);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        pixel = 8'h00; up = 8'h00; down = 8'h33; left = 8'h00; right = 8'h44;
        #1;

        check_outputs(8'h33);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        pixel = 8'h00; up = 8'h01; down = 8'h02; left = 8'h03; right = 8'h04;
        #1;

        check_outputs(8'h01);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        pixel = 8'hFF; up = 8'hFF; down = 8'hFF; left = 8'hFF; right = 8'hFF;
        #1;

        check_outputs(8'hFF);
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
        input [7:0] expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
