`timescale 1ns/1ps

module chacha20_qr_tb;

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
    chacha20_qr dut (
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
            $display("\nTest Case %0d: All Zeros", test_num);
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
            $display("\nTest Case %0d: Specific Input Pattern 1", test_num);
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
            $display("\nTest Case %0d: All Ones", test_num);
            a = 32'hffffffff;
            b = 32'hffffffff;
            c = 32'hffffffff;
            d = 32'hffffffff;





            #1;






            check_outputs(32'h0000fffd, 32'h00018001, 32'h0200fcff, 32'h01fffd00);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTest Case %0d: Mixed Hex Pattern", test_num);
            a = 32'h87654321;
            b = 32'h12345678;
            c = 32'hdeadbeef;
            d = 32'hcafebabe;





            #1;






            check_outputs(32'had7c7ad7, 32'h5e11ed24, 32'h5cfec2e4, 32'h5b29b08e);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTest Case %0d: Alternating Bits", test_num);
            a = 32'haaaaaaaa;
            b = 32'h55555555;
            c = 32'haaaaaaaa;
            d = 32'h55555555;





            #1;






            check_outputs(32'h00000fff, 32'hd557877f, 32'hffaaaf0e, 32'haa555aaa);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("chacha20_qr Testbench");
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
