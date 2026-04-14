`timescale 1ns/1ps

module mux_forwarding_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] a;
    reg [4:0] b;
    reg forward_en;
    reg sel;
    wire [4:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mux_forwarding dut (
        .a(a),
        .b(b),
        .forward_en(forward_en),
        .sel(sel),
        .y(y)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Normal Mux - Select Input A (forward_en=0, sel=0)", test_num);
        a = 5'h0A;
        b = 5'h15;
        forward_en = 0;
        sel = 0;
        #1;

        check_outputs(5'h0A);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Normal Mux - Select Input B (forward_en=0, sel=1)", test_num);
        a = 5'h0A;
        b = 5'h15;
        forward_en = 0;
        sel = 1;
        #1;

        check_outputs(5'h15);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Forwarding Enabled - Overriding sel=0", test_num);
        a = 5'h1F;
        b = 5'h00;
        forward_en = 1;
        sel = 0;
        #1;

        check_outputs(5'h1F);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Forwarding Enabled - Overriding sel=1", test_num);
        a = 5'h07;
        b = 5'h18;
        forward_en = 1;
        sel = 1;
        #1;

        check_outputs(5'h07);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Data Change while Forwarding Active", test_num);
        a = 5'h11;
        b = 5'h0E;
        forward_en = 1;
        sel = 1;
        #2;
        a = 5'h12;
        #1;

        check_outputs(5'h12);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Boundary values (All 1s vs All 0s)", test_num);
        a = 5'b00000;
        b = 5'b11111;
        forward_en = 0;
        sel = 1;
        #1;

        check_outputs(5'b11111);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Disabling forwarding restores selection", test_num);
        a = 5'h05;
        b = 5'h1A;
        forward_en = 1;
        sel = 1;
        #2;
        forward_en = 0;
        #1;

        check_outputs(5'h1A);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("mux_forwarding Testbench");
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
        input [4:0] expected_y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: y=%h",
                         y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: y=%h",
                         expected_y);
                $display("  Got:      y=%h",
                         y);
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
