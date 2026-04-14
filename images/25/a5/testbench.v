`timescale 1ns/1ps

module slam_simulator_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [4:0] map_update;
    reg [4:0] position_update;
    reg rst;
    wire [9:0] estimated_position;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    slam_simulator dut (
        .clk(clk),
        .map_update(map_update),
        .position_update(position_update),
        .rst(rst),
        .estimated_position(estimated_position)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            map_update = 5'b0;
            position_update = 5'b0;
            @(posedge clk);
            #1 rst = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Running Test Case 001: Reset State Check...");
            reset_dut();

            #1;


            check_outputs(10'b00000_00000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Running Test Case 002: Single Step Update...");
            reset_dut();
            position_update = 5'd10;
            map_update = 5'd5;
            @(posedge clk);
            #1;

            #1;


            check_outputs({5'd10, 5'd5});
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Running Test Case 003: Multiple Step Accumulation...");
            reset_dut();


            position_update = 5'd2;
            map_update = 5'd3;
            @(posedge clk);


            position_update = 5'd10;
            map_update = 5'd1;
            @(posedge clk);

            #1;

            #1;


            check_outputs({5'd12, 5'd4});
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Running Test Case 004: Maximum Value Check...");
            reset_dut();
            position_update = 5'd31;
            map_update = 5'd31;
            @(posedge clk);
            #1;

            #1;


            check_outputs(10'b11111_11111);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Running Test Case 005: Overflow Wrap-around Check...");
            reset_dut();


            position_update = 5'd31;
            map_update = 5'd31;
            @(posedge clk);


            position_update = 5'd2;
            map_update = 5'd2;
            @(posedge clk);

            #1;

            #1;


            check_outputs({5'd1, 5'd1});
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("slam_simulator Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        
        
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
        input [9:0] expected_estimated_position;
        begin
            if (expected_estimated_position === (expected_estimated_position ^ estimated_position ^ expected_estimated_position)) begin
                $display("PASS");
                $display("  Outputs: estimated_position=%h",
                         estimated_position);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: estimated_position=%h",
                         expected_estimated_position);
                $display("  Got:      estimated_position=%h",
                         estimated_position);
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
        $dumpvars(0,clk, map_update, position_update, rst, estimated_position);
    end

endmodule
