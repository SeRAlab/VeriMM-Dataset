`timescale 1ns/1ps

module ecc_point_addition_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg start;
    reg [31:0] x1;
    reg [31:0] x2;
    reg [31:0] y1;
    reg [31:0] y2;
    wire done;
    wire [31:0] x3;
    wire [31:0] y3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ecc_point_addition dut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .x1(x1),
        .x2(x2),
        .y1(y1),
        .y2(y2),
        .done(done),
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
            start = 0;
            x1 = 0;
            y1 = 0;
            x2 = 0;
            y2 = 0;
            repeat (2) @(posedge clk);
            rst = 0;
            repeat (1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning Testcase 001: Standard Addition (P != Q)");
            test_num = 1;
            reset_dut();

            x1 = 32'd5;
            y1 = 32'd1;
            x2 = 32'd6;
            y2 = 32'd3;
            start = 1;

            @(posedge clk);
            start = 0;


            wait(done);


            #1;



            check_outputs(1'b1, 32'd10, 32'd6);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning Testcase 002: Point Doubling (P == Q)");
            test_num = 2;
            reset_dut();

            x1 = 32'd5;
            y1 = 32'd1;
            x2 = 32'd5;
            y2 = 32'd1;
            start = 1;

            @(posedge clk);
            start = 0;

            wait(done);


            #1;



            check_outputs(1'b1, 32'd6, 32'd3);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning Testcase 003: Identity Addition (P + O)");
            test_num = 3;
            reset_dut();

            x1 = 32'd10;
            y1 = 32'd6;
            x2 = 32'd0;
            y2 = 32'd0;
            start = 1;

            @(posedge clk);
            start = 0;

            wait(done);


            #1;



            check_outputs(1'b1, 32'd10, 32'd6);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning Testcase 004: Inverse Points (P + (-P))");
            test_num = 4;
            reset_dut();

            x1 = 32'd5;
            y1 = 32'd1;
            x2 = 32'd5;
            y2 = 32'd16;
            start = 1;

            @(posedge clk);
            start = 0;

            wait(done);


            #1;



            check_outputs(1'b1, 32'd0, 32'd0);
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning Testcase 005: Large Coordinate Addition");
            test_num = 5;
            reset_dut();

            x1 = 32'hFFFF_FFFF;
            y1 = 32'hAAAA_AAAA;
            x2 = 32'h1234_5678;
            y2 = 32'h8765_4321;
            start = 1;

            @(posedge clk);
            start = 0;



            wait(done);

            if (done === 1'b1) begin
                $display("PASS: FSM Completed operation for large values.");
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: FSM Failed to signal done.");
                fail_count = fail_count + 1;
            end
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
        input expected_done;
        input [31:0] expected_x3;
        input [31:0] expected_y3;
        begin
            if (expected_done === (expected_done ^ done ^ expected_done) &&
                expected_x3 === (expected_x3 ^ x3 ^ expected_x3) &&
                expected_y3 === (expected_y3 ^ y3 ^ expected_y3)) begin
                $display("PASS");
                $display("  Outputs: done=%b, x3=%h, y3=%h",
                         done, x3, y3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: done=%b, x3=%h, y3=%h",
                         expected_done, expected_x3, expected_y3);
                $display("  Got:      done=%b, x3=%h, y3=%h",
                         done, x3, y3);
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
        $dumpvars(0,clk, rst, start, x1, x2, y1, y2, done, x3, y3);
    end

endmodule
