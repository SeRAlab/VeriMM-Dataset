`timescale 1ns/1ps

module floyd_warshall_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] dist_0;
    reg [15:0] dist_1;
    reg [15:0] dist_2;
    reg [15:0] dist_3;
    reg reset;
    wire [15:0] path_0;
    wire [15:0] path_1;
    wire [15:0] path_2;
    wire [15:0] path_3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    floyd_warshall dut (
        .clk(clk),
        .dist_0(dist_0),
        .dist_1(dist_1),
        .dist_2(dist_2),
        .dist_3(dist_3),
        .reset(reset),
        .path_0(path_0),
        .path_1(path_1),
        .path_2(path_2),
        .path_3(path_3)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            dist_0 = 16'h0FFF;
            dist_1 = 16'hF0FF;
            dist_2 = 16'hFF0F;
            dist_3 = 16'hFFF0;
            repeat(5) @(posedge clk);
            reset = 0;
            repeat(2) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Basic Chain with Shortcut", test_num);
            reset_dut();
            dist_0 = 16'h02AF;
            dist_1 = 16'hF03F;
            dist_2 = 16'hFF0F;
            dist_3 = 16'hFFF0;


            repeat(100) @(posedge clk);

            #1;


            check_outputs(16'h025F, 16'hF03F, 16'hFF0F, 16'hFFF0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Circular Graph", test_num);
            reset_dut();
            dist_0 = 16'h01FF;
            dist_1 = 16'hF01F;
            dist_2 = 16'hFF01;
            dist_3 = 16'h1FF0;

            repeat(100) @(posedge clk);






            #1;







            check_outputs(16'h0123, 16'h3012, 16'h2301, 16'h1230);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Disconnected Components", test_num);
            reset_dut();
            dist_0 = 16'h03FF;
            dist_1 = 16'h30FF;
            dist_2 = 16'hFF04;
            dist_3 = 16'hFFF0;

            repeat(100) @(posedge clk);

            #1;


            check_outputs(16'h03FF, 16'h30FF, 16'hFF04, 16'hFFF0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Fully Connected / Multi-hop", test_num);
            reset_dut();

            dist_0 = 16'h01F9;
            dist_1 = 16'hF01F;
            dist_2 = 16'hFF01;
            dist_3 = 16'hF5F0;

            repeat(100) @(posedge clk);






            #1;







            check_outputs(16'h0123, 16'hF012, 16'hF601, 16'hF560);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("floyd_warshall Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        
        
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
        input [15:0] expected_path_0;
        input [15:0] expected_path_1;
        input [15:0] expected_path_2;
        input [15:0] expected_path_3;
        begin
            if (expected_path_0 === (expected_path_0 ^ path_0 ^ expected_path_0) &&
                expected_path_1 === (expected_path_1 ^ path_1 ^ expected_path_1) &&
                expected_path_2 === (expected_path_2 ^ path_2 ^ expected_path_2) &&
                expected_path_3 === (expected_path_3 ^ path_3 ^ expected_path_3)) begin
                $display("PASS");
                $display("  Outputs: path_0=%h, path_1=%h, path_2=%h, path_3=%h",
                         path_0, path_1, path_2, path_3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: path_0=%h, path_1=%h, path_2=%h, path_3=%h",
                         expected_path_0, expected_path_1, expected_path_2, expected_path_3);
                $display("  Got:      path_0=%h, path_1=%h, path_2=%h, path_3=%h",
                         path_0, path_1, path_2, path_3);
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
        $dumpvars(0,clk, dist_0, dist_1, dist_2, dist_3, reset, path_0, path_1, path_2, path_3);
    end

endmodule
