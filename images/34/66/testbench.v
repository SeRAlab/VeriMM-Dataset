`timescale 1ns/1ps

module pipelined_multiplier_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] a;
    reg [7:0] b;
    reg clk;
    reg rst;
    wire [15:0] product;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pipelined_multiplier dut (
        .a(a),
        .b(b),
        .clk(clk),
        .rst(rst),
        .product(product)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            a = 0;
            b = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            a = 8'd0; b = 8'd0;
            a_reg = a; b_reg = b;
            @(posedge clk);
            a = 8'hFF; b = 8'hFF;
            repeat(6) @(posedge clk);
            #1 #1;
 check_outputs(16'd0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            a = 8'd255; b = 8'd255;
            a_reg = a; b_reg = b;
            @(posedge clk);
            a = 0; b = 0;
            repeat(6) @(posedge clk);
            #1 #1;
 check_outputs(16'd65025);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            a = 8'd12; b = 8'd10;
            a_reg = a; b_reg = b;
            @(posedge clk);
            a = 0; b = 0;
            repeat(6) @(posedge clk);
            #1 #1;
 check_outputs(16'd120);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            a = 8'd128; b = 8'd1;
            a_reg = a; b_reg = b;
            @(posedge clk);
            a = 0; b = 0;
            repeat(6) @(posedge clk);
            #1 #1;
 check_outputs(16'd128);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            a = 8'd16; b = 8'd16;
            a_reg = a; b_reg = b;
            @(posedge clk);
            a = 0; b = 0;
            repeat(6) @(posedge clk);
            #1 #1;
 check_outputs(16'd256);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            a = 8'd13; b = 8'd17;
            a_reg = a; b_reg = b;
            @(posedge clk);
            a = 0; b = 0;
            repeat(6) @(posedge clk);
            #1 #1;
 check_outputs(16'd221);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("pipelined_multiplier Testbench");
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
        input [15:0] expected_product;
        begin
            if (expected_product === (expected_product ^ product ^ expected_product)) begin
                $display("PASS");
                $display("  Outputs: product=%h",
                         product);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: product=%h",
                         expected_product);
                $display("  Got:      product=%h",
                         product);
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
        $dumpvars(0,a, b, clk, rst, product);
    end

endmodule
