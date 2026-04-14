`timescale 1ns/1ps

module hough_transform_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] x;
    reg [7:0] y;
    wire [15:0] rho;
    wire [7:0] theta;
    wire [15:0] votes;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    hough_transform dut (
        .x(x),
        .y(y),
        .rho(rho),
        .theta(theta),
        .votes(votes)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("\nTest Case %0d: Input (0,0)", test_num);
            x = 8'd0;
            y = 8'd0;

            #1;


            check_outputs(16'h0000, 8'h00, 16'h0001);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTest Case %0d: Input (100,0)", test_num);
            x = 8'd100;
            y = 8'd0;


            #1;



            check_outputs(16'h0064, 8'h00, 16'h0001);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTest Case %0d: Input (0,50)", test_num);
            x = 8'd0;
            y = 8'd50;


            #1;



            check_outputs(16'h0032, 8'h5A, 16'h0001);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTest Case %0d: Input (10,10)", test_num);
            x = 8'd10;
            y = 8'd10;


            #1;



            check_outputs(16'h000E, 8'h2D, 16'h0001);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTest Case %0d: Input (255,255)", test_num);
            x = 8'd255;
            y = 8'd255;


            #1;



            check_outputs(16'h0169, 8'h2D, 16'h0001);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTest Case %0d: Input (200,150) for vertical detection", test_num);
            x = 8'd200;
            y = 8'd150;


            #1;



            check_outputs(16'h00C8, 8'h00, 16'h0001);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("hough_transform Testbench");
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
        input [15:0] expected_rho;
        input [7:0] expected_theta;
        input [15:0] expected_votes;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_rho === (expected_rho ^ rho ^ expected_rho) &&
                expected_theta === (expected_theta ^ theta ^ expected_theta) &&
                expected_votes === (expected_votes ^ votes ^ expected_votes)) begin
                $display("PASS");
                $display("  Outputs: rho=%h, theta=%h, votes=%h",
                         rho, theta, votes);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rho=%h, theta=%h, votes=%h",
                         expected_rho, expected_theta, expected_votes);
                $display("  Got:      rho=%h, theta=%h, votes=%h",
                         rho, theta, votes);
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
