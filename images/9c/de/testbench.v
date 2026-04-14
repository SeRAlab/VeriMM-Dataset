`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [195:0] A;
    wire [195:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .out(out)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: All zeros", test_num);
        A = 196'h0;
        #1;

        check_outputs(196'h0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: All ones", test_num);
        A = {196{1'b1}};

        #1;


        check_outputs({ {194{1'b1}}, 2'b00 });
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: Least significant bit set", test_num);
        A = 196'h1;

        #1;


        check_outputs(196'h4);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: Most significant bits set (should shift out)", test_num);
        A = (196'h3 << 194);

        #1;


        check_outputs(196'h0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: Alternating bit pattern (AAAA...)", test_num);

        A = {49{4'hA}};

        #1;


        check_outputs({49{4'hA}} << 2);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %0d: Alternating bit pattern (5555...)", test_num);

        A = {49{4'h5}};
        #1;

        check_outputs({49{4'h5}} << 2);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test %0d: Walking bit test (bit 193)", test_num);
        A = (196'h1 << 193);

        #1;


        check_outputs(196'h1 << 195);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test %0d: Random pattern verify", test_num);
        A = 196'hDEADBEEFCAFEBABE12345678876543210FEDCBA9876543210;
        #1;

        check_outputs(196'hDEADBEEFCAFEBABE12345678876543210FEDCBA9876543210 << 2);
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
        input [195:0] expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
