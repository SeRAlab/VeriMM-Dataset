`timescale 1ns/1ps

module multiplier_pipe_32bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg i_en;
    reg [31:0] mul_a;
    reg [31:0] mul_b;
    reg rst_n;
    wire o_en;
    wire [63:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    multiplier_pipe_32bit dut (
        .clk(clk),
        .i_en(i_en),
        .mul_a(mul_a),
        .mul_b(mul_b),
        .rst_n(rst_n),
        .o_en(o_en),
        .result(result)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            i_en = 0;
            mul_a = 0;
            mul_b = 0;
            repeat(2) @(posedge clk);
            #1 rst_n = 1;
            repeat(1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic multiplication (12 * 11)", test_num);
            reset_dut();
            mul_a = 32'd12;
            mul_b = 32'd11;
            i_en = 1;
            @(posedge clk);
            i_en = 0;


            while (!o_en) @(posedge clk);
            #1;

            check_outputs(1'b1, 64'd132);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Multiplication by zero (0 * 12345)", test_num);
            reset_dut();
            mul_a = 32'd0;
            mul_b = 32'd12345;
            i_en = 1;
            @(posedge clk);
            i_en = 0;

            while (!o_en) @(posedge clk);
            #1;

            check_outputs(1'b1, 64'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Maximum 32-bit values (FFFFFFFF * FFFFFFFF)", test_num);
            reset_dut();
            mul_a = 32'hFFFF_FFFF;
            mul_b = 32'hFFFF_FFFF;
            i_en = 1;
            @(posedge clk);
            i_en = 0;

            while (!o_en) @(posedge clk);

            #1;


            check_outputs(1'b1, 64'hFFFF_FFFE_0000_0001);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Multiplication by one (1 * 0xABCDEF12)", test_num);
            reset_dut();
            mul_a = 32'd1;
            mul_b = 32'hABCDEF12;
            i_en = 1;
            @(posedge clk);
            i_en = 0;

            while (!o_en) @(posedge clk);
            #1;

            check_outputs(1'b1, 64'h0000_0000_ABCDEF12);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Power of two multiplication (2^10 * 2^20)", test_num);
            reset_dut();
            mul_a = 32'h0000_0400;
            mul_b = 32'h0010_0000;
            i_en = 1;
            @(posedge clk);
            i_en = 0;

            while (!o_en) @(posedge clk);
            #1;

            check_outputs(1'b1, 64'h0000_0000_4000_0000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Sequential inputs check (last result)", test_num);
            reset_dut();


            mul_a = 32'd2; mul_b = 32'd2; i_en = 1;
            @(posedge clk);

            mul_a = 32'd5; mul_b = 32'd5; i_en = 1;
            @(posedge clk);

            mul_a = 32'd10; mul_b = 32'd10; i_en = 1;
            @(posedge clk);
            i_en = 0;




            repeat(1) begin
                while (!o_en) @(posedge clk);
                @(posedge clk);
                @(posedge clk);
            end


            #1;



            check_outputs(1'b1, 64'd100);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("multiplier_pipe_32bit Testbench");
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
        input expected_o_en;
        input [63:0] expected_result;
        begin
            if (expected_o_en === (expected_o_en ^ o_en ^ expected_o_en) &&
                expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: o_en=%b, result=%h",
                         o_en, result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o_en=%b, result=%h",
                         expected_o_en, expected_result);
                $display("  Got:      o_en=%b, result=%h",
                         o_en, result);
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
        $dumpvars(0,clk, i_en, mul_a, mul_b, rst_n, o_en, result);
    end

endmodule
