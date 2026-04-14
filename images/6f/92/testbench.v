`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [9:0] a;
    reg [9:0] b;
    wire [19:0] p;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .p(p)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        a = 10'd0;
        b = 10'd0;
        $display("Testcase %0d: a=%d, b=%d", test_num, a, b);
        #1;

        check_outputs(20'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        a = 10'd1023;
        b = 10'd1023;
        $display("Testcase %0d: a=%d, b=%d", test_num, a, b);
        #1;

        check_outputs(20'd1046529);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        a = 10'd512;
        b = 10'd1;
        $display("Testcase %0d: a=%d, b=%d", test_num, a, b);
        #1;

        check_outputs(20'd512);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        a = 10'd32;
        b = 10'd32;
        $display("Testcase %0d: a=%d, b=%d", test_num, a, b);
        #1;

        check_outputs(20'd1024);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        a = 10'd123;
        b = 10'd456;
        $display("Testcase %0d: a=%d, b=%d", test_num, a, b);
        #1;

        check_outputs(20'd56088);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        a = 10'd31;
        b = 10'd31;
        $display("Testcase %0d: a=%d, b=%d", test_num, a, b);
        #1;

        check_outputs(20'd961);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        a = 10'd992;
        b = 10'd2;
        $display("Testcase %0d: a=%d, b=%d", test_num, a, b);
        #1;

        check_outputs(20'd1984);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        a = 10'h155;
        b = 10'h2AA;
        $display("Testcase %0d: a=0x%h, b=0x%h", test_num, a, b);
        #1;

        check_outputs(20'd232562);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        a = 10'd1000;
        b = 10'd10;
        $display("Testcase %0d: a=%d, b=%d", test_num, a, b);
        #1;

        check_outputs(20'd10000);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        a = 10'd797;
        b = 10'd821;
        $display("Testcase %0d: a=%d, b=%d", test_num, a, b);
        #1;

        check_outputs(20'd654337);
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
        input [19:0] expected_p;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_p === (expected_p ^ p ^ expected_p)) begin
                $display("PASS");
                $display("  Outputs: p=%h",
                         p);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: p=%h",
                         expected_p);
                $display("  Got:      p=%h",
                         p);
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
