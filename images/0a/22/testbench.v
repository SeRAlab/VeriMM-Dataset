`timescale 1ns/1ps

module ecc_point_addition_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] x1;
    reg [15:0] x2;
    reg [15:0] y1;
    reg [15:0] y2;
    wire [15:0] x3;
    wire [15:0] y3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ecc_point_addition dut (
        .clk(clk),
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
            rst_n = 0;
            x1 = 16'h0;
            y1 = 16'h0;
            x2 = 16'h0;
            y2 = 16'h0;
            repeat(2) @(posedge clk);
            rst_n = 1;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Point Addition (P + Q)", test_num);
            reset_dut();

            x1 = 16'h0005; y1 = 16'h0001;
            x2 = 16'h0006; y2 = 16'h0003;


            repeat(10) @(posedge clk);

            #1;


            check_outputs(16'h000A, 16'h0006);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Point Doubling (P + P)", test_num);
            reset_dut();

            x1 = 16'h0005; y1 = 16'h0001;
            x2 = 16'h0005; y2 = 16'h0001;

            repeat(10) @(posedge clk);

            #1;


            check_outputs(16'h0006, 16'h0003);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Commutativity (Q + P)", test_num);
            reset_dut();

            x1 = 16'h0006; y1 = 16'h0003;
            x2 = 16'h0005; y2 = 16'h0001;

            repeat(10) @(posedge clk);

            #1;


            check_outputs(16'h000A, 16'h0006);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Chained Addition", test_num);
            reset_dut();

            x1 = 16'h000A; y1 = 16'h0006;
            x2 = 16'h0005; y2 = 16'h0001;

            repeat(10) @(posedge clk);

            #1;


            check_outputs(16'h0003, 16'h0001);
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
        input [15:0] expected_x3;
        input [15:0] expected_y3;
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
        $dumpvars(0,clk, x1, x2, y1, y2, x3, y3);
    end

endmodule
