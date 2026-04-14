`timescale 1ns/1ps

module chacha20_quarter_round_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] a;
    reg [31:0] b;
    reg [31:0] c;
    reg [31:0] d;
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
        .d(d),
        .out_a(out_a),
        .out_b(out_b),
        .out_c(out_c),
        .out_d(out_d)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: All Zeros", test_num);
            a = 32'h00000000;
            b = 32'h00000000;
            c = 32'h00000000;
            d = 32'h00000000;


            #1;



            check_outputs(32'h00000000, 32'h00000000, 32'h00000000, 32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: RFC 7539 Reference Vector", test_num);

            a = 32'h11111111;
            b = 32'h01020304;
            c = 32'h9b8d6f43;
            d = 32'h01234567;



            #1;




            check_outputs(32'hea2a92f4, 32'hcb1cf8ce, 32'h4581472e, 32'h5881c4bb);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: All Ones", test_num);
            a = 32'hffffffff;
            b = 32'hffffffff;
            c = 32'hffffffff;
            d = 32'hffffffff;






            #1;







            check_outputs(32'hefffffff, 32'h800088f8, 32'hef00ffee, 32'heeffffef);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Large Values with Carry", test_num);
            a = 32'h879531e0;
            b = 32'hc5ecf37d;
            c = 32'h516461b1;
            d = 32'hd9a6ec43;


            #1;



            check_outputs(32'hbb543423, 32'h7947ff7a, 32'h137d2162, 32'h69122f9e);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Walking Bit Pattern", test_num);
            a = 32'h00000001;
            b = 32'h00000002;
            c = 32'h00000004;
            d = 32'h00000008;






            #1;







            check_outputs(32'hb0006003, 32'h85b1da5e, 32'h0d0b03b4, 32'h0d0003b0);
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
            #1; // Small delay for combinational logic to settle
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

endmodule
