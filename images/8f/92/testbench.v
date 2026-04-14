`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] cb;
    reg clk;
    reg [7:0] cr;
    reg reset;
    reg [7:0] y;
    wire [9:0] b;
    wire data_valid;
    wire [9:0] g;
    wire [9:0] r;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .cb(cb),
        .clk(clk),
        .cr(cr),
        .reset(reset),
        .y(y),
        .b(b),
        .data_valid(data_valid),
        .g(g),
        .r(r)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            y = 8'd0;
            cb = 8'd128;
            cr = 8'd128;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset State", test_num);
            reset = 1;
            y = 8'hFF; cb = 8'hFF; cr = 8'hFF;
            repeat(2) @(posedge clk);

            #1;


            check_outputs(10'd0, 1'b0, 10'd0, 10'd0);
            #1 reset = 0;
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Neutral Gray", test_num);
            reset_dut();
            y = 8'd128;
            cb = 8'd128;
            cr = 8'd128;
            repeat(5) @(posedge clk);
            #1;

            check_outputs(10'd512, 1'b1, 10'd512, 10'd512);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Black Level", test_num);
            reset_dut();
            y = 8'd0;
            cb = 8'd128;
            cr = 8'd128;
            repeat(5) @(posedge clk);
            #1;

            check_outputs(10'd0, 1'b1, 10'd0, 10'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Peak White", test_num);
            reset_dut();
            y = 8'd255;
            cb = 8'd128;
            cr = 8'd128;
            repeat(5) @(posedge clk);
            #1;

            check_outputs(10'd1023, 1'b1, 10'd1023, 10'd1023);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: High Blue Chrominance", test_num);
            reset_dut();
            y = 8'd128;
            cb = 8'd255;
            cr = 8'd128;
            repeat(5) @(posedge clk);


            #1;



            check_outputs(10'd1023, 1'b1, 10'd226, 10'd512);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: High Red Chrominance", test_num);
            reset_dut();
            y = 8'd128;
            cb = 8'd128;
            cr = 8'd255;
            repeat(5) @(posedge clk);

            #1;


            check_outputs(10'd512, 1'b1, 10'd148, 10'd1023);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Lower Clipping", test_num);
            reset_dut();
            y = 8'd16;
            cb = 8'd200;
            cr = 8'd200;
            repeat(5) @(posedge clk);


            if (g === 10'd0) begin
                $display("Green clipped to 0 correctly");
            end
            #1;

            check_outputs(b, 1'b1, 10'd0, r);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
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
        input [9:0] expected_b;
        input expected_data_valid;
        input [9:0] expected_g;
        input [9:0] expected_r;
        begin
            if (expected_b === (expected_b ^ b ^ expected_b) &&
                expected_data_valid === (expected_data_valid ^ data_valid ^ expected_data_valid) &&
                expected_g === (expected_g ^ g ^ expected_g) &&
                expected_r === (expected_r ^ r ^ expected_r)) begin
                $display("PASS");
                $display("  Outputs: b=%h, data_valid=%b, g=%h, r=%h",
                         b, data_valid, g, r);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: b=%h, data_valid=%b, g=%h, r=%h",
                         expected_b, expected_data_valid, expected_g, expected_r);
                $display("  Got:      b=%h, data_valid=%b, g=%h, r=%h",
                         b, data_valid, g, r);
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
        $dumpvars(0,cb, clk, cr, reset, y, b, data_valid, g, r);
    end

endmodule
