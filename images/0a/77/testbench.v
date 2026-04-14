`timescale 1ns/1ps

module slam_position_estimator_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] distance;
    reg reset;
    wire [7:0] position;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    slam_position_estimator dut (
        .clk(clk),
        .distance(distance),
        .reset(reset),
        .position(position)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            distance = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Checking initial position after reset", test_num);
            reset_dut();

            #1;


            check_outputs(8'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Single movement update", test_num);
            reset_dut();
            distance = 8'd15;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'd15);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Multiple sequential distance updates", test_num);
            reset_dut();
            distance = 8'd10; @(posedge clk); #1;
            distance = 8'd20; @(posedge clk); #1;
            distance = 8'd5;  @(posedge clk); #1;

            #1;


            check_outputs(8'd35);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Checking position wrap-around (overflow)", test_num);
            reset_dut();
            distance = 8'd200; @(posedge clk); #1;
            distance = 8'd100; @(posedge clk); #1;

            #1;


            check_outputs(8'd44);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Update with maximum distance value (255)", test_num);
            reset_dut();
            distance = 8'd255; @(posedge clk); #1;
            distance = 8'd1;   @(posedge clk); #1;

            #1;


            check_outputs(8'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Zero distance update", test_num);
            reset_dut();
            distance = 8'd50; @(posedge clk); #1;
            distance = 8'd0;  @(posedge clk); #1;
            distance = 8'd0;  @(posedge clk); #1;

            #1;


            check_outputs(8'd50);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("slam_position_estimator Testbench");
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
        input [7:0] expected_position;
        begin
            if (expected_position === (expected_position ^ position ^ expected_position)) begin
                $display("PASS");
                $display("  Outputs: position=%h",
                         position);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: position=%h",
                         expected_position);
                $display("  Got:      position=%h",
                         position);
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,clk, distance, reset, position);
    end

endmodule
