`timescale 1ns/1ps

module eight_bit_adder_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] a;
    reg [7:0] b;
    reg cin;
    wire cout;
    wire [7:0] s;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    eight_bit_adder dut (
        .a(a),
        .b(b),
        .cin(cin),
        .cout(cout),
        .s(s)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: All Zeros", test_num);
        a = 8'h00;
        b = 8'h00;
        cin = 1'b0;
        #1;

        check_outputs(1'b0, 8'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Simple addition without carry", test_num);
        a = 8'h05;
        b = 8'h0A;
        cin = 1'b0;
        #1;

        check_outputs(1'b0, 8'h0F);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Addition with cin set", test_num);
        a = 8'h10;
        b = 8'h20;
        cin = 1'b1;
        #1;

        check_outputs(1'b0, 8'h31);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Result is exactly 255 (Max 8-bit, no cout)", test_num);
        a = 8'hFF;
        b = 8'h00;
        cin = 1'b0;
        #1;

        check_outputs(1'b0, 8'hFF);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Result triggers cout (255 + 1)", test_num);
        a = 8'hFF;
        b = 8'h01;
        cin = 1'b0;
        #1;

        check_outputs(1'b1, 8'h00);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Result triggers cout via cin (255 + 0 + 1)", test_num);
        a = 8'hFF;
        b = 8'h00;
        cin = 1'b1;
        #1;

        check_outputs(1'b1, 8'h00);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Maximum possible sum (255 + 255 + 1)", test_num);
        a = 8'hFF;
        b = 8'hFF;
        cin = 1'b1;

        #1;


        check_outputs(1'b1, 8'hFF);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Mid-range overflow (128 + 128)", test_num);
        a = 8'h80;
        b = 8'h80;
        cin = 1'b0;
        #1;

        check_outputs(1'b1, 8'h00);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Alternating bits pattern", test_num);
        a = 8'hAA;
        b = 8'h55;
        cin = 1'b0;
        #1;

        check_outputs(1'b0, 8'hFF);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Alternating bits pattern with carry-in", test_num);
        a = 8'hAA;
        b = 8'h55;
        cin = 1'b1;

        #1;


        check_outputs(1'b1, 8'h00);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("eight_bit_adder Testbench");
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
        input expected_cout;
        input [7:0] expected_s;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_cout === (expected_cout ^ cout ^ expected_cout) &&
                expected_s === (expected_s ^ s ^ expected_s)) begin
                $display("PASS");
                $display("  Outputs: cout=%b, s=%h",
                         cout, s);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cout=%b, s=%h",
                         expected_cout, expected_s);
                $display("  Got:      cout=%b, s=%h",
                         cout, s);
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
