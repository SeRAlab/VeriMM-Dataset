`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] a;
    reg [7:0] b;
    reg [7:0] c;
    reg [7:0] d;
    wire [7:0] outx;
    wire [7:0] outy;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .c(c),
        .d(d),
        .outx(outx),
        .outy(outy)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: All Inputs Zero", test_num);
        a = 8'h00; b = 8'h00; c = 8'h00; d = 8'h00;
        #1;

        check_outputs(8'h00, 8'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Unit Vector A", test_num);
        a = 8'h01; b = 8'h00; c = 8'h00; d = 8'h00;
        #1;

        check_outputs(8'h02, 8'h01);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Unit Vector B", test_num);
        a = 8'h00; b = 8'h01; c = 8'h00; d = 8'h00;
        #1;

        check_outputs(8'h03, 8'h02);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Unit Vector C", test_num);
        a = 8'h00; b = 8'h00; c = 8'h01; d = 8'h00;
        #1;

        check_outputs(8'h01, 8'h03);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Unit Vector D", test_num);
        a = 8'h00; b = 8'h00; c = 8'h00; d = 8'h01;
        #1;

        check_outputs(8'h01, 8'h01);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: AES Standard Vector 1", test_num);
        a = 8'hd4; b = 8'hbf; c = 8'h5d; d = 8'h30;
        #1;

        check_outputs(8'h04, 8'h66);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: AES Standard Vector 2", test_num);
        a = 8'hb1; b = 8'h59; c = 8'h35; d = 8'h5f;
        #1;

        check_outputs(8'hf8, 8'h03);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: All Maximum Values", test_num);
        a = 8'hff; b = 8'hff; c = 8'hff; d = 8'hff;
        #1;

        check_outputs(8'hff, 8'hff);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: High Bit Triggers (xtime logic check)", test_num);
        a = 8'h80; b = 8'h40; c = 8'h20; d = 8'h10;
        #1;

        check_outputs(8'heb, 8'h70);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Pattern Inputs", test_num);
        a = 8'h12; b = 8'h34; c = 8'h56; d = 8'h78;
        #1;

        check_outputs(8'h56, 8'hf8);
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
        input [7:0] expected_outx;
        input [7:0] expected_outy;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_outx === (expected_outx ^ outx ^ expected_outx) &&
                expected_outy === (expected_outy ^ outy ^ expected_outy)) begin
                $display("PASS");
                $display("  Outputs: outx=%h, outy=%h",
                         outx, outy);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: outx=%h, outy=%h",
                         expected_outx, expected_outy);
                $display("  Got:      outx=%h, outy=%h",
                         outx, outy);
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
