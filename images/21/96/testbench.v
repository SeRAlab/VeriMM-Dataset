`timescale 1ns/1ps

module position_tracker_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg rst;
    reg [15:0] x_in;
    reg [15:0] y_in;
    wire [15:0] x_out;
    wire [15:0] y_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    position_tracker dut (
        .clk(clk),
        .enable(enable),
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
            enable = 0;
            x_in = 16'h0;
            y_in = 16'h0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %03d: Post-reset initial state check", test_num);
            reset_dut();

            #1;


            check_outputs(16'h0000, 16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %03d: Single position update", test_num);
            reset_dut();
            enable = 1;
            x_in = 16'h1234;
            y_in = 16'h5678;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h1234, 16'h5678);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %03d: Enable signal functionality (ignore input when enable is low)", test_num);
            reset_dut();

            enable = 1;
            x_in = 16'hAAAA;
            y_in = 16'hBBBB;
            @(posedge clk);

            #1;
            enable = 0;
            x_in = 16'hFFFF;
            y_in = 16'hFFFF;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'hAAAA, 16'hBBBB);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %03d: Multiple sequential updates", test_num);
            reset_dut();
            enable = 1;

            x_in = 16'h0001; y_in = 16'h0001;
            @(posedge clk);

            #1 x_in = 16'h0002; y_in = 16'h0002;
            @(posedge clk);

            #1 x_in = 16'h0003; y_in = 16'h0003;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0003, 16'h0003);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %03d: Boundary values update (0xFFFF)", test_num);
            reset_dut();
            enable = 1;
            x_in = 16'hFFFF;
            y_in = 16'hFFFF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'hFFFF, 16'hFFFF);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %03d: Mid-operation reset check", test_num);
            reset_dut();
            enable = 1;
            x_in = 16'h1111;
            y_in = 16'h2222;
            @(posedge clk);

            #1 rst = 1;
            @(posedge clk);
            #1 rst = 0;
            #1;

            check_outputs(16'h0000, 16'h0000);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case %03d: Toggle enable while changing data", test_num);
            reset_dut();

            enable = 1; x_in = 16'h1010; y_in = 16'h2020;
            @(posedge clk);

            #1 enable = 0; x_in = 16'h3030; y_in = 16'h4040;
            @(posedge clk);

            #1 enable = 1; x_in = 16'h5050; y_in = 16'h6060;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h5050, 16'h6060);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("position_tracker Testbench");
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
        input [15:0] expected_x_out;
        input [15:0] expected_y_out;
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
        $dumpvars(0,clk, enable, rst, x_in, y_in, x_out, y_out);
    end

endmodule
