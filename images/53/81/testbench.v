`timescale 1ns/1ps

module adder_32bit_tb;

    // Testbench signals (combinational circuit)
    reg Cin;
    reg [31:0] a;
    reg [31:0] b;
    wire Co;
    wire [31:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    adder_32bit dut (
        .Cin(Cin),
        .a(a),
        .b(b),
        .Co(Co),
        .y(y)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: All Zeros addition", test_num);
        a = 32'h0000_0000;
        b = 32'h0000_0000;
        Cin = 0;
        #1;

        check_outputs(1'b0, 32'h0000_0000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Simple addition without carry", test_num);
        a = 32'h1234_5678;
        b = 32'h1111_1111;
        Cin = 0;
        #1;

        check_outputs(1'b0, 32'h2345_6789);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Carry-in verification", test_num);
        a = 32'h0000_0001;
        b = 32'h0000_0001;
        Cin = 1;
        #1;

        check_outputs(1'b0, 32'h0000_0003);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Internal carry propagation (16-bit boundary)", test_num);

        a = 32'h0000_FFFF;
        b = 32'h0000_0000;
        Cin = 1;
        #1;

        check_outputs(1'b0, 32'h0001_0000);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Upper bits addition with carry-out", test_num);
        a = 32'hFFFF_0000;
        b = 32'h0001_0000;
        Cin = 0;
        #1;

        check_outputs(1'b1, 32'h0000_0000);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Maximum operands with Carry-in", test_num);
        a = 32'hFFFF_FFFF;
        b = 32'hFFFF_FFFF;
        Cin = 1;
        #1;

        check_outputs(1'b1, 32'hFFFF_FFFF);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Alternating bit patterns", test_num);
        a = 32'hAAAA_AAAA;
        b = 32'h5555_5555;
        Cin = 0;
        #1;

        check_outputs(1'b0, 32'hFFFF_FFFF);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: Large sum resulting in carry-out", test_num);
        a = 32'h8000_0000;
        b = 32'h8000_0000;
        Cin = 0;
        #1;

        check_outputs(1'b1, 32'h0000_0000);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("adder_32bit Testbench");
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
        input expected_Co;
        input [31:0] expected_y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Co === (expected_Co ^ Co ^ expected_Co) &&
                expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: Co=%b, y=%h",
                         Co, y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Co=%b, y=%h",
                         expected_Co, expected_y);
                $display("  Got:      Co=%b, y=%h",
                         Co, y);
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
