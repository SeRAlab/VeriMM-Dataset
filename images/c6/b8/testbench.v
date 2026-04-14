`timescale 1ns/1ps

module adder_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] a;
    reg [7:0] b;
    wire [8:0] c;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    adder dut (
        .a(a),
        .b(b),
        .c(c)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Zero addition", test_num);
        a = 8'h00;
        b = 8'h00;
        #1;

        check_outputs(9'h000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Simple addition without overflow", test_num);
        a = 8'h05;
        b = 8'h0A;
        #1;

        check_outputs(9'h00F);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Maximum value without truncation", test_num);
        a = 8'h7F;
        b = 8'h80;
        #1;

        check_outputs(9'h0FF);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Addition resulting in exactly 256 (Truncation check)", test_num);
        a = 8'hFF;
        b = 8'h01;

        #1;


        check_outputs(9'h000);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Addition resulting in 257 (Truncation check)", test_num);
        a = 8'hFF;
        b = 8'h02;

        #1;


        check_outputs(9'h001);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Max overflow addition (255 + 255)", test_num);
        a = 8'hFF;
        b = 8'hFF;

        #1;


        check_outputs(9'h0FE);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Mid-range values with truncation", test_num);
        a = 8'd200;
        b = 8'd100;

        #1;


        check_outputs(9'h02C);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("adder Testbench");
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
        input [8:0] expected_c;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_c === (expected_c ^ c ^ expected_c)) begin
                $display("PASS");
                $display("  Outputs: c=%h",
                         c);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: c=%h",
                         expected_c);
                $display("  Got:      c=%h",
                         c);
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
