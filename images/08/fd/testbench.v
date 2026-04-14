`timescale 1ns/1ps

module slam_system_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] current_position;
    reg [7:0] landmark_data;
    reg reset;
    wire [7:0] updated_position;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    slam_system dut (
        .clk(clk),
        .current_position(current_position),
        .landmark_data(landmark_data),
        .reset(reset),
        .updated_position(updated_position)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            current_position = 0;
            landmark_data = 0;
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
            $display("Test %0d: Stationary at Origin", test_num);
            reset_dut();
            current_position = 8'd0;
            landmark_data = 8'd0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Perfect Agreement at 100", test_num);
            reset_dut();
            current_position = 8'd100;
            landmark_data = 8'd100;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'd100);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Forward Movement Fusion", test_num);
            reset_dut();
            current_position = 8'd10;
            landmark_data = 8'd30;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'd20);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Backward Movement Fusion", test_num);
            reset_dut();
            current_position = 8'd200;
            landmark_data = 8'd100;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'd150);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Wide Variance Fusion", test_num);
            reset_dut();
            current_position = 8'd0;
            landmark_data = 8'd254;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'd127);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Boundary Fusion (Max)", test_num);
            reset_dut();
            current_position = 8'd255;
            landmark_data = 8'd255;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'd255);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("slam_system Testbench");
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
        input [7:0] expected_updated_position;
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
        $dumpvars(0,clk, current_position, landmark_data, reset, updated_position);
    end

endmodule
