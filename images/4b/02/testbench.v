`timescale 1ns/1ps

module pe_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] a;
    reg [31:0] b;
    reg clk;
    reg rst;
    wire [31:0] c;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pe dut (
        .a(a),
        .b(b),
        .clk(clk),
        .rst(rst),
        .c(c)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(posedge clk);
            rst = 1;
            a = 0;
            b = 0;
            @(posedge clk);
            #1;
            rst = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Basic Reset", test_num);
            reset_dut();

            #1;


            check_outputs(32'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Single Multiply-Accumulate (10 * 5)", test_num);
            reset_dut();
            a = 32'd10;
            b = 32'd5;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'd50);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Multiple Sequential Accumulations (3*4 + 5*6)", test_num);
            reset_dut();

            a = 32'd3; b = 32'd4;
            @(posedge clk);

            a = 32'd5; b = 32'd6;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'd42);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Multiplication by Zero", test_num);
            reset_dut();

            a = 32'd10; b = 32'd10;
            @(posedge clk);

            a = 32'd5; b = 32'd0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'd100);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: 32-bit Wraparound Logic", test_num);
            reset_dut();


            a = 32'hFFFFFFFF; b = 32'd1;
            @(posedge clk);

            a = 32'd1; b = 32'd1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Larger Value Multiplication", test_num);
            reset_dut();

            a = 32'd1000; b = 32'd2000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'd2000000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("pe Testbench");
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
        input [31:0] expected_c;
        begin
            if (expected_c === (expected_c ^ c ^ expected_c)) begin
                $display("PASS");
                $display("  Outputs: c=%h",
                         c);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: c=%h",
                         expected_c);
                $display("  Got:      c=%h",
                         c);
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
        $dumpvars(0,a, b, clk, rst, c);
    end

endmodule
