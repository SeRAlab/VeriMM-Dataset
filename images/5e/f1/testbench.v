`timescale 1ns/1ps

module subtractor_8bit_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] a;
    reg [7:0] b;
    wire borrow_out;
    wire [7:0] diff;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    subtractor_8bit dut (
        .a(a),
        .b(b),
        .borrow_out(borrow_out),
        .diff(diff)
    );
    task testcase001;

    begin
        test_num = 1;
        a = 8'd10; b = 8'd5;
        $display("Testcase %03d: a=%d, b=%d", test_num, a, b);
        #1;

        check_outputs(1'b0, 8'd5);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        a = 8'd255; b = 8'd255;
        $display("Testcase %03d: a=%d, b=%d", test_num, a, b);
        #1;

        check_outputs(1'b0, 8'd0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        a = 8'd0; b = 8'd1;
        $display("Testcase %03d: a=%d, b=%d", test_num, a, b);
        #1;

        check_outputs(1'b1, 8'd255);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        a = 8'd255; b = 8'd0;
        $display("Testcase %03d: a=%d, b=%d", test_num, a, b);
        #1;

        check_outputs(1'b0, 8'd255);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        a = 8'd128; b = 8'd200;
        $display("Testcase %03d: a=%d, b=%d", test_num, a, b);

        #1;


        check_outputs(1'b1, 8'd184);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        a = 8'd0; b = 8'd0;
        $display("Testcase %03d: a=%d, b=%d", test_num, a, b);
        #1;

        check_outputs(1'b0, 8'd0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        a = 8'd127; b = 8'd128;
        $display("Testcase %03d: a=%d, b=%d", test_num, a, b);

        #1;


        check_outputs(1'b1, 8'd255);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        a = 8'hA5; b = 8'h12;
        $display("Testcase %03d: a=%h, b=%h", test_num, a, b);
        #1;

        check_outputs(1'b0, 8'h93);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("subtractor_8bit Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        
        
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
        input expected_borrow_out;
        input [7:0] expected_diff;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_borrow_out === (expected_borrow_out ^ borrow_out ^ expected_borrow_out) &&
                expected_diff === (expected_diff ^ diff ^ expected_diff)) begin
                $display("PASS");
                $display("  Outputs: borrow_out=%b, diff=%h",
                         borrow_out, diff);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: borrow_out=%b, diff=%h",
                         expected_borrow_out, expected_diff);
                $display("  Got:      borrow_out=%b, diff=%h",
                         borrow_out, diff);
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
