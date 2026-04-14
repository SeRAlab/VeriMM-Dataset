`timescale 1ns/1ps

module chacha20_quarter_round_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] a;
    reg [31:0] b;
    reg [31:0] c;
    reg [31:0] d;
    wire [31:0] o_a;
    wire [31:0] o_b;
    wire [31:0] o_c;
    wire [31:0] o_d;

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
        .o_a(o_a),
        .o_b(o_b),
        .o_c(o_c),
        .o_d(o_d)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros", test_num);
            a = 32'h0; b = 32'h0; c = 32'h0; d = 32'h0;
            #1;

            check_outputs(32'h0, 32'h0, 32'h0, 32'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Ones", test_num);
            a = 32'h1; b = 32'h1; c = 32'h1; d = 32'h1;
            #1;

            check_outputs(32'h30000002, 32'h81811899, 32'h03030231, 32'h03000230);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Addition Overflow", test_num);
            a = 32'hFFFFFFFF; b = 32'h00000001; c = 32'h0; d = 32'h0;
            #1;

            check_outputs(32'h00001000, 32'h08080000, 32'h00100000, 32'h00100000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Standard Vector 1", test_num);
            a = 32'h11111111; b = 32'h01020304; c = 32'h9b8d6f43; d = 32'h01234567;
            #1;

            check_outputs(32'hea2a92f4, 32'hcb1cf8ce, 32'h4581472e, 32'h5881c4bb);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Standard Vector 2", test_num);
            a = 32'h879531e0; b = 32'hc5ec5164; c = 32'h9c648115; d = 32'h28af2d58;
            #1;

            check_outputs(32'h18f3fb0a, 32'h36b91f79, 32'h391f0af8, 32'hef9e24b5);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: High Entropy Pattern", test_num);
            a = 32'hdeadbeef; b = 32'h12345678; c = 32'hfacefeed; d = 32'h87654321;
            #1;

            check_outputs(32'h62e2d999, 32'he0a84d43, 32'hf5c194a8, 32'ha4ae1e34);
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
        input [31:0] expected_o_a;
        input [31:0] expected_o_b;
        input [31:0] expected_o_c;
        input [31:0] expected_o_d;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_o_a === (expected_o_a ^ o_a ^ expected_o_a) &&
                expected_o_b === (expected_o_b ^ o_b ^ expected_o_b) &&
                expected_o_c === (expected_o_c ^ o_c ^ expected_o_c) &&
                expected_o_d === (expected_o_d ^ o_d ^ expected_o_d)) begin
                $display("PASS");
                $display("  Outputs: o_a=%h, o_b=%h, o_c=%h, o_d=%h",
                         o_a, o_b, o_c, o_d);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o_a=%h, o_b=%h, o_c=%h, o_d=%h",
                         expected_o_a, expected_o_b, expected_o_c, expected_o_d);
                $display("  Got:      o_a=%h, o_b=%h, o_c=%h, o_d=%h",
                         o_a, o_b, o_c, o_d);
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
