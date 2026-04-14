`timescale 1ns/1ps

module slam_position_update_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] current_position;
    reg [3:0] new_observation;
    reg rst;
    wire [3:0] updated_position;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    slam_position_update dut (
        .clk(clk),
        .current_position(current_position),
        .new_observation(new_observation),
        .rst(rst),
        .updated_position(updated_position)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            current_position = 0;
            new_observation = 0;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            current_position = 4'd5;
            new_observation = 4'd3;
            @(posedge clk);
            #2;
            $display("Test Case %0d: 5 + 3 = 8", test_num);
            #1;

            check_outputs(4'd8);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            current_position = 4'd12;
            new_observation = 4'd6;
            @(posedge clk);
            #2;
            $display("Test Case %0d: 12 + 6 = 18 (Modulo 16 = 2)", test_num);
            #1;

            check_outputs(4'd2);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            current_position = 4'd7;
            new_observation = 4'd0;
            @(posedge clk);
            #2;
            $display("Test Case %0d: 7 + 0 = 7", test_num);
            #1;

            check_outputs(4'd7);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            current_position = 4'd15;
            new_observation = 4'd15;
            @(posedge clk);
            #2;
            $display("Test Case %0d: 15 + 15 = 30 (Modulo 16 = 14)", test_num);
            #1;

            check_outputs(4'd14);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            current_position = 4'd8;
            new_observation = 4'd8;
            @(posedge clk);
            #2;
            $display("Test Case %0d: 8 + 8 = 16 (Modulo 16 = 0)", test_num);
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_dut();
            current_position = 4'd1;
            new_observation = 4'd1;


            @(posedge clk);
            #2;
            $display("Test Case %0d: Post-reset addition 1 + 1 = 2", test_num);
            #1;

            check_outputs(4'd2);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("slam_position_update Testbench");
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
        input [3:0] expected_updated_position;
        begin
            if (expected_updated_position === (expected_updated_position ^ updated_position ^ expected_updated_position)) begin
                $display("PASS");
                $display("  Outputs: updated_position=%h",
                         updated_position);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: updated_position=%h",
                         expected_updated_position);
                $display("  Got:      updated_position=%h",
                         updated_position);
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
        $dumpvars(0,clk, current_position, new_observation, rst, updated_position);
    end

endmodule
