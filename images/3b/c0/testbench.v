`timescale 1ns/1ps

module conv3x3_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [8:0] image;
    reg [8:0] kernel;
    reg rst;
    wire [9:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    conv3x3 dut (
        .clk(clk),
        .image(image),
        .kernel(kernel),
        .rst(rst),
        .result(result)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        image = 0;
        kernel = 0;
        @(posedge clk);
        #1;
        rst = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: All Zeros", test_num);
        reset_dut();
        image = 9'b000_000_000;
        kernel = 9'b000_000_000;

        repeat(15) @(posedge clk);
        #1;

        check_outputs(10'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: All Ones (Maximum result)", test_num);
        reset_dut();
        image = 9'b111_111_111;
        kernel = 9'b111_111_111;
        repeat(15) @(posedge clk);
        #1;

        check_outputs(10'd9);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Specific Pattern Match (Center and corners)", test_num);
        reset_dut();



        image = 9'b101_010_101;
        kernel = 9'b111_111_111;
        repeat(15) @(posedge clk);
        #1;

        check_outputs(10'd5);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Diagonal Pattern", test_num);
        reset_dut();



        image = 9'b100_010_001;
        kernel = 9'b100_010_001;
        repeat(15) @(posedge clk);
        #1;

        check_outputs(10'd3);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Orthogonal Patterns (No overlap)", test_num);
        reset_dut();


        image  = 9'b000_000_111;
        kernel = 9'b111_000_000;
        repeat(15) @(posedge clk);
        #1;

        check_outputs(10'd0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Checkerboard Pattern", test_num);
        reset_dut();



        image  = 9'b101_010_101;
        kernel = 9'b010_101_010;
        repeat(15) @(posedge clk);
        #1;

        check_outputs(10'd0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Partial Overlap", test_num);
        reset_dut();



        image  = 9'b000_000_111;
        kernel = 9'b100_100_100;
        repeat(15) @(posedge clk);
        #1;

        check_outputs(10'd1);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("conv3x3 Testbench");
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
        input [9:0] expected_result;
        begin
            if (expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: result=%h",
                         result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result=%h",
                         expected_result);
                $display("  Got:      result=%h",
                         result);
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
        $dumpvars(0,clk, image, kernel, rst, result);
    end

endmodule
