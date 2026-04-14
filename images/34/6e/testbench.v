`timescale 1ns/1ps

module rrt_midpoint_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] x1;
    reg [4:0] x2;
    reg [4:0] y1;
    reg [4:0] y2;
    wire [9:0] midpoint;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    rrt_midpoint dut (
        .x1(x1),
        .x2(x2),
        .y1(y1),
        .y2(y2),
        .midpoint(midpoint)
    );
    task testcase001;

    begin
        test_num = 1;
        x1 = 5'd0; y1 = 5'd0;
        x2 = 5'd0; y2 = 5'd0;

        #1;


        check_outputs(10'h000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        x1 = 5'd31; y1 = 5'd31;
        x2 = 5'd31; y2 = 5'd31;

        #1;


        check_outputs(10'h3FF);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        x1 = 5'd0;  y1 = 5'd0;
        x2 = 5'd31; y2 = 5'd31;


        #1;



        check_outputs(10'h1EF);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        x1 = 5'd10; y1 = 5'd20;
        x2 = 5'd30; y2 = 5'd4;



        #1;




        check_outputs(10'h28C);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        x1 = 5'd1; y1 = 5'd1;
        x2 = 5'd2; y2 = 5'd2;



        #1;




        check_outputs(10'h021);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        x1 = 5'd5;  y1 = 5'd25;
        x2 = 5'd14; y2 = 5'd2;



        #1;




        check_outputs(10'h12D);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        x1 = 5'd30; y1 = 5'd30;
        x2 = 5'd31; y2 = 5'd31;



        #1;




        check_outputs(10'h3DE);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("rrt_midpoint Testbench");
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
        input [9:0] expected_midpoint;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_midpoint === (expected_midpoint ^ midpoint ^ expected_midpoint)) begin
                $display("PASS");
                $display("  Outputs: midpoint=%h",
                         midpoint);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: midpoint=%h",
                         expected_midpoint);
                $display("  Got:      midpoint=%h",
                         midpoint);
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
