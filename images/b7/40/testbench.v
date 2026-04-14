`timescale 1ns/1ps

module subtractor_32bit_tb;

    // Testbench signals (combinational circuit)
    reg Bin;
    reg [31:0] a;
    reg [31:0] b;
    wire Bout;
    wire [31:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    subtractor_32bit dut (
        .Bin(Bin),
        .a(a),
        .b(b),
        .Bout(Bout),
        .y(y)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Simple subtraction (10 - 5, Bin=0)", test_num);
        a = 32'd10;
        b = 32'd5;
        Bin = 1'b0;

        #1;


        check_outputs(1'b0, 32'd5);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Simple subtraction with Bin (10 - 5, Bin=1)", test_num);
        a = 32'd10;
        b = 32'd5;
        Bin = 1'b1;

        #1;


        check_outputs(1'b0, 32'd4);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Resulting in borrow out (5 - 10, Bin=0)", test_num);
        a = 32'd5;
        b = 32'd10;
        Bin = 1'b0;

        #1;


        check_outputs(1'b1, 32'hFFFFFFFB);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Zero subtraction with Bin (0 - 0, Bin=1)", test_num);
        a = 32'h0;
        b = 32'h0;
        Bin = 1'b1;

        #1;


        check_outputs(1'b1, 32'hFFFFFFFF);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Boundary borrow check (0x00010000 - 1, Bin=0)", test_num);
        a = 32'h00010000;
        b = 32'h00000001;
        Bin = 1'b0;

        #1;


        check_outputs(1'b0, 32'h0000FFFF);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Maximum values (FFFFFFFF - FFFFFFFF, Bin=0)", test_num);
        a = 32'hFFFFFFFF;
        b = 32'hFFFFFFFF;
        Bin = 1'b0;

        #1;


        check_outputs(1'b0, 32'h00000000);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Max values with Bin (0 - FFFFFFFF, Bin=1)", test_num);
        a = 32'h00000000;
        b = 32'hFFFFFFFF;
        Bin = 1'b1;

        #1;


        check_outputs(1'b1, 32'h00000000);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Alternating bits subtraction", test_num);
        a = 32'hAAAAAAAA;
        b = 32'h55555555;
        Bin = 1'b0;

        #1;


        check_outputs(1'b0, 32'h55555555);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Ripple borrow (0x80000000 - 0x80000001, Bin=0)", test_num);
        a = 32'h80000000;
        b = 32'h80000001;
        Bin = 1'b0;

        #1;


        check_outputs(1'b1, 32'hFFFFFFFF);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Arbitrary subtraction", test_num);
        a = 32'h12345678;
        b = 32'h02345679;
        Bin = 1'b1;

        #1;


        check_outputs(1'b0, 32'h0FFFFFFF);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("subtractor_32bit Testbench");
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
        input expected_Bout;
        input [31:0] expected_y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Bout === (expected_Bout ^ Bout ^ expected_Bout) &&
                expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: Bout=%b, y=%h",
                         Bout, y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Bout=%b, y=%h",
                         expected_Bout, expected_y);
                $display("  Got:      Bout=%b, y=%h",
                         Bout, y);
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
