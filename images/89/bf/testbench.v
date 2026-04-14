`timescale 1ns/1ps

module mux2to1_32bit_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] a;
    reg [31:0] b;
    reg sel;
    wire [31:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mux2to1_32bit dut (
        .a(a),
        .b(b),
        .sel(sel),
        .y(y)
    );
    task testcase001;

    begin
        test_num = 1;
        a = 32'h0000_0000;
        b = 32'hFFFF_FFFF;
        sel = 1'b0;
        $display("Testcase %03d: Select A (All Zeros) with sel=0", test_num);
        #1;

        check_outputs(32'h0000_0000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        a = 32'h0000_0000;
        b = 32'hFFFF_FFFF;
        sel = 1'b1;
        $display("Testcase %03d: Select B (All Ones) with sel=1", test_num);
        #1;

        check_outputs(32'hFFFF_FFFF);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        a = 32'hAAAA_AAAA;
        b = 32'h5555_5555;
        sel = 1'b0;
        $display("Testcase %03d: Select A (Alternating A) with sel=0", test_num);
        #1;

        check_outputs(32'hAAAA_AAAA);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        a = 32'hAAAA_AAAA;
        b = 32'h5555_5555;
        sel = 1'b1;
        $display("Testcase %03d: Select B (Alternating 5) with sel=1", test_num);
        #1;

        check_outputs(32'h5555_5555);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        a = 32'h1234_5678;
        b = 32'h9ABC_DEF0;
        sel = 1'b0;
        $display("Testcase %03d: Select A (Hex Sequence) with sel=0", test_num);
        #1;

        check_outputs(32'h1234_5678);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        a = 32'h1234_5678;
        b = 32'h9ABC_DEF0;
        sel = 1'b1;
        $display("Testcase %03d: Select B (Hex Sequence) with sel=1", test_num);
        #1;

        check_outputs(32'h9ABC_DEF0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        a = 32'hDEAD_BEEF;
        b = 32'hCAFE_BABE;
        sel = 1'b0;
        $display("Testcase %03d: Select A (Named Constants) with sel=0", test_num);
        #1;

        check_outputs(32'hDEAD_BEEF);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        a = 32'hDEAD_BEEF;
        b = 32'hCAFE_BABE;
        sel = 1'b1;
        $display("Testcase %03d: Select B (Named Constants) with sel=1", test_num);
        #1;

        check_outputs(32'hCAFE_BABE);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("mux2to1_32bit Testbench");
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
        input [31:0] expected_y;
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
