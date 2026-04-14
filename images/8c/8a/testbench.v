`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] a;
    reg [1:0] b;
    wire [2:0] d;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .d(d)
    );
    task testcase001;

    begin
        a = 2'b00; b = 2'b00;
        test_num = test_num + 1;
        $display("Test %0d: a=%b, b=%b", test_num, a, b);
        #1;

        check_outputs(3'b000);
    end
        endtask

    task testcase002;

    begin
        a = 2'b00; b = 2'b01;
        test_num = test_num + 1;
        $display("Test %0d: a=%b, b=%b", test_num, a, b);
        #1;

        check_outputs(3'b000);
    end
        endtask

    task testcase003;

    begin
        a = 2'b01; b = 2'b00;
        test_num = test_num + 1;
        $display("Test %0d: a=%b, b=%b", test_num, a, b);
        #1;

        check_outputs(3'b000);
    end
        endtask

    task testcase004;

    begin
        a = 2'b01; b = 2'b01;
        test_num = test_num + 1;
        $display("Test %0d: a=%b, b=%b", test_num, a, b);
        #1;

        check_outputs(3'b001);
    end
        endtask

    task testcase005;

    begin
        a = 2'b10; b = 2'b10;
        test_num = test_num + 1;
        $display("Test %0d: a=%b, b=%b", test_num, a, b);
        #1;

        check_outputs(3'b100);
    end
        endtask

    task testcase006;

    begin
        a = 2'b01; b = 2'b10;
        test_num = test_num + 1;
        $display("Test %0d: a=%b, b=%b", test_num, a, b);
        #1;

        check_outputs(3'b010);
    end
        endtask

    task testcase007;

    begin
        a = 2'b10; b = 2'b01;
        test_num = test_num + 1;
        $display("Test %0d: a=%b, b=%b", test_num, a, b);
        #1;

        check_outputs(3'b010);
    end
        endtask

    task testcase008;

    begin
        a = 2'b11; b = 2'b11;
        test_num = test_num + 1;
        $display("Test %0d: a=%b, b=%b", test_num, a, b);
        #1;

        check_outputs(3'b101);
    end
        endtask

    task testcase009;

    begin
        a = 2'b11; b = 2'b01;
        test_num = test_num + 1;
        $display("Test %0d: a=%b, b=%b", test_num, a, b);
        #1;

        check_outputs(3'b011);
    end
        endtask

    task testcase010;

    begin
        a = 2'b11; b = 2'b10;
        test_num = test_num + 1;
        $display("Test %0d: a=%b, b=%b", test_num, a, b);
        #1;

        check_outputs(3'b110);
    end
        endtask

    task testcase011;

    begin
        a = 2'b01; b = 2'b11;
        test_num = test_num + 1;
        $display("Test %0d: a=%b, b=%b", test_num, a, b);
        #1;

        check_outputs(3'b011);
    end
        endtask

    task testcase012;

    begin
        a = 2'b10; b = 2'b11;
        test_num = test_num + 1;
        $display("Test %0d: a=%b, b=%b", test_num, a, b);
        #1;

        check_outputs(3'b110);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        testcase009();
        testcase010();
        testcase011();
        testcase012();
        
        
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
        input [2:0] expected_d;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_d === (expected_d ^ d ^ expected_d)) begin
                $display("PASS");
                $display("  Outputs: d=%h",
                         d);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: d=%h",
                         expected_d);
                $display("  Got:      d=%h",
                         d);
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
