`timescale 1ns/1ps

module subtractor3bit_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] a;
    reg [2:0] b;
    wire borrow_out;
    wire [2:0] difference;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    subtractor3bit dut (
        .a(a),
        .b(b),
        .borrow_out(borrow_out),
        .difference(difference)
    );
    task testcase001;

        begin
            test_num = 1;
            a = 3'b000;
            b = 3'b000;
            $display("Test %0d: a=%d, b=%d", test_num, a, b);
            #1;

            check_outputs(1'b0, 3'b000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            a = 3'b111;
            b = 3'b000;
            $display("Test %0d: a=%d, b=%d", test_num, a, b);
            #1;

            check_outputs(1'b0, 3'b111);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            a = 3'b111;
            b = 3'b111;
            $display("Test %0d: a=%d, b=%d", test_num, a, b);
            #1;

            check_outputs(1'b0, 3'b000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            a = 3'b011;
            b = 3'b001;
            $display("Test %0d: a=%d, b=%d", test_num, a, b);
            #1;

            check_outputs(1'b0, 3'b010);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            a = 3'b001;
            b = 3'b010;
            $display("Test %0d: a=%d, b=%d", test_num, a, b);
            #1;

            check_outputs(1'b1, 3'b111);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            a = 3'b000;
            b = 3'b001;
            $display("Test %0d: a=%d, b=%d", test_num, a, b);
            #1;

            check_outputs(1'b1, 3'b111);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            a = 3'b000;
            b = 3'b111;
            $display("Test %0d: a=%d, b=%d", test_num, a, b);
            #1;

            check_outputs(1'b1, 3'b001);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            a = 3'b100;
            b = 3'b110;
            $display("Test %0d: a=%d, b=%d", test_num, a, b);
            #1;

            check_outputs(1'b1, 3'b110);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("subtractor3bit Testbench");
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
        input [2:0] expected_difference;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_borrow_out === (expected_borrow_out ^ borrow_out ^ expected_borrow_out) &&
                expected_difference === (expected_difference ^ difference ^ expected_difference)) begin
                $display("PASS");
                $display("  Outputs: borrow_out=%b, difference=%h",
                         borrow_out, difference);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: borrow_out=%b, difference=%h",
                         expected_borrow_out, expected_difference);
                $display("  Got:      borrow_out=%b, difference=%h",
                         borrow_out, difference);
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
