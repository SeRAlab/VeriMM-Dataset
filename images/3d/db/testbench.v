`timescale 1ns/1ps

module floyd_warshall_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] dist_00;
    reg [7:0] dist_01;
    reg [7:0] dist_02;
    reg [7:0] dist_10;
    reg [7:0] dist_11;
    reg [7:0] dist_12;
    reg [7:0] dist_20;
    reg [7:0] dist_21;
    reg [7:0] dist_22;
    reg reset;
    wire [7:0] out_00;
    wire [7:0] out_01;
    wire [7:0] out_02;
    wire [7:0] out_10;
    wire [7:0] out_11;
    wire [7:0] out_12;
    wire [7:0] out_20;
    wire [7:0] out_21;
    wire [7:0] out_22;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    floyd_warshall dut (
        .clk(clk),
        .dist_00(dist_00),
        .dist_01(dist_01),
        .dist_02(dist_02),
        .dist_10(dist_10),
        .dist_11(dist_11),
        .dist_12(dist_12),
        .dist_20(dist_20),
        .dist_21(dist_21),
        .dist_22(dist_22),
        .reset(reset),
        .out_00(out_00),
        .out_01(out_01),
        .out_02(out_02),
        .out_10(out_10),
        .out_11(out_11),
        .out_12(out_12),
        .out_20(out_20),
        .out_21(out_21),
        .out_22(out_22)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            #10;
            @(posedge clk);
            #1;
            reset = 0;

            repeat (10) @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Identity Matrix (Disconnected Graph)", test_num);
            dist_00 = 8'h00; dist_01 = 8'hFF; dist_02 = 8'hFF;
            dist_10 = 8'hFF; dist_11 = 8'h00; dist_12 = 8'hFF;
            dist_20 = 8'hFF; dist_21 = 8'hFF; dist_22 = 8'h00;
            reset_dut();
            #1;

            check_outputs(8'h00, 8'hFF, 8'hFF, 8'hFF, 8'h00, 8'hFF, 8'hFF, 8'hFF, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Simple Chain (0->1->2)", test_num);
            dist_00 = 8'h00; dist_01 = 8'h0A; dist_02 = 8'hFF;
            dist_10 = 8'hFF; dist_11 = 8'h00; dist_12 = 8'h14;
            dist_20 = 8'hFF; dist_21 = 8'hFF; dist_22 = 8'h00;
            reset_dut();

            #1;


            check_outputs(8'h00, 8'h0A, 8'h1E, 8'hFF, 8'h00, 8'h14, 8'hFF, 8'hFF, 8'h00);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Shortcut Discovery", test_num);
            dist_00 = 8'h00; dist_01 = 8'h05; dist_02 = 8'h64;
            dist_10 = 8'hFF; dist_11 = 8'h00; dist_12 = 8'h05;
            dist_20 = 8'hFF; dist_21 = 8'hFF; dist_22 = 8'h00;
            reset_dut();

            #1;


            check_outputs(8'h00, 8'h05, 8'h0A, 8'hFF, 8'h00, 8'h05, 8'hFF, 8'hFF, 8'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Directed Ring Graph", test_num);
            dist_00 = 8'h00; dist_01 = 8'h0A; dist_02 = 8'hFF;
            dist_10 = 8'hFF; dist_11 = 8'h00; dist_12 = 8'h0A;
            dist_20 = 8'h0A; dist_21 = 8'hFF; dist_22 = 8'h00;
            reset_dut();

            #1;


            check_outputs(8'h00, 8'h0A, 8'h14, 8'h14, 8'h00, 8'h0A, 8'h0A, 8'h14, 8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Complex Fully Connected Graph", test_num);
            dist_00 = 8'h00; dist_01 = 8'h32; dist_02 = 8'h05;
            dist_10 = 8'h02; dist_11 = 8'h00; dist_12 = 8'h32;
            dist_20 = 8'h32; dist_21 = 8'h05; dist_22 = 8'h00;
            reset_dut();



            #1;




            check_outputs(8'h00, 8'h0A, 8'h05, 8'h02, 8'h00, 8'h07, 8'h07, 8'h05, 8'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Disconnected Components", test_num);
            dist_00 = 8'h00; dist_01 = 8'h0F; dist_02 = 8'hFF;
            dist_10 = 8'h0F; dist_11 = 8'h00; dist_12 = 8'hFF;
            dist_20 = 8'hFF; dist_21 = 8'hFF; dist_22 = 8'h00;
            reset_dut();
            #1;

            check_outputs(8'h00, 8'h0F, 8'hFF, 8'h0F, 8'h00, 8'hFF, 8'hFF, 8'hFF, 8'h00);
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
        input [7:0] expected_out_00;
        input [7:0] expected_out_01;
        input [7:0] expected_out_02;
        input [7:0] expected_out_10;
        input [7:0] expected_out_11;
        input [7:0] expected_out_12;
        input [7:0] expected_out_20;
        input [7:0] expected_out_21;
        input [7:0] expected_out_22;
        begin
            if (expected_out_00 === (expected_out_00 ^ out_00 ^ expected_out_00) &&
                expected_out_01 === (expected_out_01 ^ out_01 ^ expected_out_01) &&
                expected_out_02 === (expected_out_02 ^ out_02 ^ expected_out_02) &&
                expected_out_10 === (expected_out_10 ^ out_10 ^ expected_out_10) &&
                expected_out_11 === (expected_out_11 ^ out_11 ^ expected_out_11) &&
                expected_out_12 === (expected_out_12 ^ out_12 ^ expected_out_12) &&
                expected_out_20 === (expected_out_20 ^ out_20 ^ expected_out_20) &&
                expected_out_21 === (expected_out_21 ^ out_21 ^ expected_out_21) &&
                expected_out_22 === (expected_out_22 ^ out_22 ^ expected_out_22)) begin
                $display("PASS");
                $display("  Outputs: out_00=%h, out_01=%h, out_02=%h, out_10=%h, out_11=%h, out_12=%h, out_20=%h, out_21=%h, out_22=%h",
                         out_00, out_01, out_02, out_10, out_11, out_12, out_20, out_21, out_22);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_00=%h, out_01=%h, out_02=%h, out_10=%h, out_11=%h, out_12=%h, out_20=%h, out_21=%h, out_22=%h",
                         expected_out_00, expected_out_01, expected_out_02, expected_out_10, expected_out_11, expected_out_12, expected_out_20, expected_out_21, expected_out_22);
                $display("  Got:      out_00=%h, out_01=%h, out_02=%h, out_10=%h, out_11=%h, out_12=%h, out_20=%h, out_21=%h, out_22=%h",
                         out_00, out_01, out_02, out_10, out_11, out_12, out_20, out_21, out_22);
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
        $dumpvars(0,clk, dist_00, dist_01, dist_02, dist_10, dist_11, dist_12, dist_20, dist_21, dist_22, reset, out_00, out_01, out_02, out_10, out_11, out_12, out_20, out_21, out_22);
    end

endmodule
