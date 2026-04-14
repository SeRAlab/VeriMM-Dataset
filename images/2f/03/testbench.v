`timescale 1ns/1ps

module quarter_round_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] a;
    reg [31:0] b;
    reg [31:0] c;
    reg clk;
    reg [31:0] d;
    reg rst;
    wire [31:0] out_a;
    wire [31:0] out_b;
    wire [31:0] out_c;
    wire [31:0] out_d;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    quarter_round dut (
        .a(a),
        .b(b),
        .c(c),
        .clk(clk),
        .d(d),
        .rst(rst),
        .out_a(out_a),
        .out_b(out_b),
        .out_c(out_c),
        .out_d(out_d)
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
            c = 0;
            d = 0;
            #10;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros", test_num);
            a = 32'h00000000;
            b = 32'h00000000;
            c = 32'h00000000;
            d = 32'h00000000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h00000000, 32'h00000000, 32'h00000000, 32'h00000000);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: All Ones", test_num);
            a = 32'h00000001;
            b = 32'h00000001;
            c = 32'h00000001;
            d = 32'h00000001;
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'h08009080, 32'h00020000, 32'h20001000, 32'h00100120);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: 1, 2, 3, 4", test_num);
            a = 32'h00000001;
            b = 32'h00000002;
            c = 32'h00000003;
            d = 32'h00000004;
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'h18002188, 32'h00030000, 32'h30003000, 32'h00300430);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Hex Pattern (Repeated Nibbles)", test_num);
            a = 32'h11111111;
            b = 32'h22222222;
            c = 32'h33333333;
            d = 32'h44444444;
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'hDDDDDDDD, 32'h33333333, 32'h66666666, 32'hAAAAAAAA);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Addition Overflow", test_num);
            a = 32'hFFFFFFFF;
            b = 32'h00000001;
            c = 32'h00000000;
            d = 32'h00000000;
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'hFFFFFFFF, 32'h00000000, 32'h00000000, 32'h00000000);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: ChaCha-like Constants", test_num);
            a = 32'h61707865;
            b = 32'h33326261;
            c = 32'h70616e64;
            d = 32'h00000000;
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'hEA9572C8, 32'hDAC694A2, 32'h803064B2, 32'h3064B280);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Complex Hex Values", test_num);
            a = 32'h87654321;
            b = 32'h12345678;
            c = 32'hfedcba98;
            d = 32'h89abcdef;
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'hA95D07BB, 32'h99999999, 32'h65431987, 32'hEFEE76EE);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("quarter_round Testbench");
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
        input [31:0] expected_out_a;
        input [31:0] expected_out_b;
        input [31:0] expected_out_c;
        input [31:0] expected_out_d;
        begin
            if (expected_out_a === (expected_out_a ^ out_a ^ expected_out_a) &&
                expected_out_b === (expected_out_b ^ out_b ^ expected_out_b) &&
                expected_out_c === (expected_out_c ^ out_c ^ expected_out_c) &&
                expected_out_d === (expected_out_d ^ out_d ^ expected_out_d)) begin
                $display("PASS");
                $display("  Outputs: out_a=%h, out_b=%h, out_c=%h, out_d=%h",
                         out_a, out_b, out_c, out_d);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_a=%h, out_b=%h, out_c=%h, out_d=%h",
                         expected_out_a, expected_out_b, expected_out_c, expected_out_d);
                $display("  Got:      out_a=%h, out_b=%h, out_c=%h, out_d=%h",
                         out_a, out_b, out_c, out_d);
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
        $dumpvars(0,a, b, c, clk, d, rst, out_a, out_b, out_c, out_d);
    end

endmodule
