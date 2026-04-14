`timescale 1ns/1ps

module ECC_PointDoubling_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg start;
    reg [31:0] x_in;
    reg [31:0] y_in;
    wire done;
    wire [31:0] x_out;
    wire [31:0] y_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ECC_PointDoubling dut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .x_in(x_in),
        .y_in(y_in),
        .done(done),
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
            start = 0;
            x_in = 32'h0;
            y_in = 32'h0;

            repeat(2) @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Doubling Point (3, 6)", test_num);
            reset_dut();

            x_in = 32'd3;
            y_in = 32'd6;
            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;


            wait(done === 1'b1);
            @(posedge clk);

            #1;


            check_outputs(1'b1, 32'd80, 32'd10);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Doubling Point (80, 10)", test_num);
            reset_dut();

            x_in = 32'd80;
            y_in = 32'd10;
            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;

            wait(done === 1'b1);
            @(posedge clk);

            #1;


            check_outputs(1'b1, 32'd3, 32'd91);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Vertical Tangent (y=0)", test_num);
            reset_dut();


            x_in = 32'h0000000A;
            y_in = 32'h00000000;
            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;

            wait(done === 1'b1);
            @(posedge clk);


            #1;



            check_outputs(1'b1, 32'h0, 32'h0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: IDLE Stability Check", test_num);
            reset_dut();

            x_in = 32'hFFFFFFFF;
            y_in = 32'hFFFFFFFF;


            repeat(5) @(posedge clk);

            if (done === 1'b0) begin
                $display("PASS: Module remained in IDLE");
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: Module signaled done without start");
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
        $display("ECC_PointDoubling Testbench");
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
        input expected_done;
        input [31:0] expected_x_out;
        input [31:0] expected_y_out;
        begin
            if (expected_done === (expected_done ^ done ^ expected_done) &&
                expected_x_out === (expected_x_out ^ x_out ^ expected_x_out) &&
                expected_y_out === (expected_y_out ^ y_out ^ expected_y_out)) begin
                $display("PASS");
                $display("  Outputs: done=%b, x_out=%h, y_out=%h",
                         done, x_out, y_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: done=%b, x_out=%h, y_out=%h",
                         expected_done, expected_x_out, expected_y_out);
                $display("  Got:      done=%b, x_out=%h, y_out=%h",
                         done, x_out, y_out);
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
        $dumpvars(0,clk, rst, start, x_in, y_in, done, x_out, y_out);
    end

endmodule
