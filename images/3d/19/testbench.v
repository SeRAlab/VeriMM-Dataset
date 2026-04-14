`timescale 1ns/1ps

module SLAMEstimator_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg new_data;
    reg rst;
    reg [4:0] x_in;
    reg [4:0] y_in;
    wire [4:0] x_out;
    wire [4:0] y_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    SLAMEstimator dut (
        .clk(clk),
        .new_data(new_data),
        .rst(rst),
        .x_in(x_in),
        .y_in(y_in),
        .x_out(x_out),
        .y_out(y_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            new_data = 0;
            x_in = 0;
            y_in = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Initial Reset Check", test_num);
            reset_dut();

            #1;


            check_outputs(5'd0, 5'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Single Data Update", test_num);
            reset_dut();
            @(posedge clk);
            new_data = 1;
            x_in = 5'd12;
            y_in = 5'd25;
            @(posedge clk);
            new_data = 0;
            #1;
            #1;

            check_outputs(5'd12, 5'd25);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Maintain Last Known Position", test_num);
            reset_dut();


            @(posedge clk);
            new_data = 1;
            x_in = 5'd5;
            y_in = 5'd10;
            @(posedge clk);


            new_data = 0;
            x_in = 5'd31;
            y_in = 5'd31;
            repeat(3) @(posedge clk);

            #1;
            #1;

            check_outputs(5'd5, 5'd10);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Multiple Consecutive Updates", test_num);
            reset_dut();

            @(posedge clk);
            new_data = 1;
            x_in = 5'd1; y_in = 5'd1;
            @(posedge clk);
            x_in = 5'd15; y_in = 5'd2;
            @(posedge clk);
            x_in = 5'd30; y_in = 5'd20;
            @(posedge clk);
            new_data = 0;

            #1;
            #1;

            check_outputs(5'd30, 5'd20);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Boundary Value Check (Max values)", test_num);
            reset_dut();

            @(posedge clk);
            new_data = 1;
            x_in = 5'b11111;
            y_in = 5'b11111;
            @(posedge clk);
            new_data = 0;

            #1;
            #1;

            check_outputs(5'd31, 5'd31);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset Priority Check", test_num);
            reset_dut();


            @(posedge clk);
            new_data = 1;
            x_in = 5'd10; y_in = 5'd10;
            @(posedge clk);


            rst = 1;
            new_data = 1;
            x_in = 5'd20; y_in = 5'd20;
            @(posedge clk);
            rst = 0;
            new_data = 0;

            #1;
            #1;

            check_outputs(5'd0, 5'd0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("SLAMEstimator Testbench");
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
        input [4:0] expected_x_out;
        input [4:0] expected_y_out;
        begin
            if (expected_x_out === (expected_x_out ^ x_out ^ expected_x_out) &&
                expected_y_out === (expected_y_out ^ y_out ^ expected_y_out)) begin
                $display("PASS");
                $display("  Outputs: x_out=%h, y_out=%h",
                         x_out, y_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: x_out=%h, y_out=%h",
                         expected_x_out, expected_y_out);
                $display("  Got:      x_out=%h, y_out=%h",
                         x_out, y_out);
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
        $dumpvars(0,clk, new_data, rst, x_in, y_in, x_out, y_out);
    end

endmodule
