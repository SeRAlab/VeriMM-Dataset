`timescale 1ns/1ps

module subtractor_16bit_tb;

    // Testbench signals (combinational circuit)
    reg Bin;
    reg [15:0] a;
    reg [15:0] b;
    wire Bo;
    wire [15:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    subtractor_16bit dut (
        .Bin(Bin),
        .a(a),
        .b(b),
        .Bo(Bo),
        .y(y)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Simple Subtraction (No Borrow-in)", test_num);
        a = 16'h000A;
        b = 16'h0003;
        Bin = 1'b0;
        #10;
        #1;

        check_outputs(1'b0, 16'h0007);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Simple Subtraction (With Borrow-in)", test_num);
        a = 16'h000A;
        b = 16'h0003;
        Bin = 1'b1;
        #10;
        #1;

        check_outputs(1'b0, 16'h0006);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Resulting in Zero", test_num);
        a = 16'h1234;
        b = 16'h1234;
        Bin = 1'b0;
        #10;
        #1;

        check_outputs(1'b0, 16'h0000);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Underflow (Borrow-out)", test_num);
        a = 16'h0000;
        b = 16'h0001;
        Bin = 1'b0;
        #10;
        #1;

        check_outputs(1'b1, 16'hFFFF);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Underflow via Borrow-in", test_num);
        a = 16'h0000;
        b = 16'h0000;
        Bin = 1'b1;
        #10;
        #1;

        check_outputs(1'b1, 16'hFFFF);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: 8-bit Boundary Check", test_num);
        a = 16'h0100;
        b = 16'h0001;
        Bin = 1'b0;
        #10;
        #1;

        check_outputs(1'b0, 16'h00FF);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Max values", test_num);
        a = 16'hFFFF;
        b = 16'hFFFE;
        Bin = 1'b0;
        #10;
        #1;

        check_outputs(1'b0, 16'h0001);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Large Underflow", test_num);
        a = 16'h0000;
        b = 16'hFFFF;
        Bin = 1'b0;
        #10;
        #1;

        check_outputs(1'b1, 16'h0001);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Mid-range values", test_num);
        a = 16'h8000;
        b = 16'h4000;
        Bin = 1'b1;
        #10;
        #1;

        check_outputs(1'b0, 16'h3FFF);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: All Ones with Borrow", test_num);
        a = 16'hFFFF;
        b = 16'hFFFF;
        Bin = 1'b1;
        #10;
        #1;

        check_outputs(1'b1, 16'hFFFF);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("subtractor_16bit Testbench");
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
        input expected_Bo;
        input [15:0] expected_y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Bo === (expected_Bo ^ Bo ^ expected_Bo) &&
                expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: Bo=%b, y=%h",
                         Bo, y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Bo=%b, y=%h",
                         expected_Bo, expected_y);
                $display("  Got:      Bo=%b, y=%h",
                         Bo, y);
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
