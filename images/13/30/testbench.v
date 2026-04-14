`timescale 1ns/1ps

module chacha20_quarter_round_tb;

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
    chacha20_quarter_round dut (
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
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning Test Case 001: All Zeros");
            test_num = test_num + 1;
            reset_dut();
            a = 32'h00000000;
            b = 32'h00000000;
            c = 32'h00000000;
            d = 32'h00000000;


            repeat(5) @(posedge clk);
            #1;

            check_outputs(32'h00000000, 32'h00000000, 32'h00000000, 32'h00000000);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning Test Case 002: RFC Reference Style");
            test_num = test_num + 1;
            reset_dut();
            a = 32'h11111111;
            b = 32'h01020304;
            c = 32'h9b8d6f43;
            d = 32'h01234567;

            repeat(5) @(posedge clk);


            #1;



            check_outputs(32'hea2a92f4, 32'hcb1cf8ce, 32'h4581472e, 32'h5881c4bb);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning Test Case 003: Carry and Overflow");
            test_num = test_num + 1;
            reset_dut();
            a = 32'h80000000;
            b = 32'h80000000;
            c = 32'h80000000;
            d = 32'h80000000;

            repeat(5) @(posedge clk);


            #1;



            check_outputs(32'h08000000, 32'h40400444, 32'h80808008, 32'h00800008);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning Test Case 004: Alternating Bit Patterns");
            test_num = test_num + 1;
            reset_dut();
            a = 32'haaaaaaaa;
            b = 32'h55555555;
            c = 32'haaaaaaaa;
            d = 32'h55555555;

            repeat(5) @(posedge clk);


            #1;



            check_outputs(32'h00000fff, 32'h555cf002, 32'h04aaa9fe, 32'haf555aaa);
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning Test Case 005: Max Word Values");
            test_num = test_num + 1;
            reset_dut();
            a = 32'hffffffff;
            b = 32'hffffffff;
            c = 32'hffffffff;
            d = 32'hffffffff;

            repeat(5) @(posedge clk);





            #1;






            check_outputs(32'hffffeffd, 32'hf88900f7, 32'heeffedfe, 32'heefffdff);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("chacha20_quarter_round Testbench");
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
