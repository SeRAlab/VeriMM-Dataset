`timescale 1ns/1ps

module ecc_point_addition_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg [63:0] x1;
    reg [63:0] x2;
    reg [63:0] y1;
    reg [63:0] y2;
    wire [63:0] x3;
    wire [63:0] y3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ecc_point_addition dut (
        .clk(clk),
        .rst(rst),
        .x1(x1),
        .x2(x2),
        .y1(y1),
        .y2(y2),
        .x3(x3),
        .y3(y3)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            x1 = 0;
            x2 = 0;
            y1 = 0;
            y2 = 0;
            @(posedge clk);
            #2;
            rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Standard Addition (P + Q)", test_num);
            reset_dut();
            x1 = 64'd5;
            y1 = 64'd1;
            x2 = 64'd6;
            y2 = 64'd3;


            repeat (20) @(posedge clk);

            #1;


            check_outputs(64'd10, 64'd6);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Point Doubling (2P)", test_num);
            reset_dut();
            x1 = 64'd5;
            y1 = 64'd1;
            x2 = 64'd5;
            y2 = 64'd1;

            repeat (20) @(posedge clk);

            #1;


            check_outputs(64'd6, 64'd3);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Additive Inverse (P + -P)", test_num);
            reset_dut();
            x1 = 64'd5;
            y1 = 64'd1;
            x2 = 64'd5;
            y2 = 64'd16;

            repeat (20) @(posedge clk);

            #1;


            check_outputs(64'd0, 64'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Identity Addition (P + O)", test_num);
            reset_dut();
            x1 = 64'd10;
            y1 = 64'd6;
            x2 = 64'd0;
            y2 = 64'd0;

            repeat (20) @(posedge clk);

            #1;


            check_outputs(64'd10, 64'd6);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Additive Inverse Case B", test_num);
            reset_dut();
            x1 = 64'd13;
            y1 = 64'd7;
            x2 = 64'd13;
            y2 = 64'd10;

            repeat (20) @(posedge clk);

            #1;


            check_outputs(64'd0, 64'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Identity Doubling (O + O)", test_num);
            reset_dut();
            x1 = 64'd0;
            y1 = 64'd0;
            x2 = 64'd0;
            y2 = 64'd0;

            repeat (20) @(posedge clk);

            #1;


            check_outputs(64'd0, 64'd0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ecc_point_addition Testbench");
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
        input [63:0] expected_x3;
        input [63:0] expected_y3;
        begin
            if (expected_x3 === (expected_x3 ^ x3 ^ expected_x3) &&
                expected_y3 === (expected_y3 ^ y3 ^ expected_y3)) begin
                $display("PASS");
                $display("  Outputs: x3=%h, y3=%h",
                         x3, y3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: x3=%h, y3=%h",
                         expected_x3, expected_y3);
                $display("  Got:      x3=%h, y3=%h",
                         x3, y3);
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
        $dumpvars(0,clk, rst, x1, x2, y1, y2, x3, y3);
    end

endmodule
